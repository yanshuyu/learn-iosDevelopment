# FoodPinDemo
My exercises while reading the appcoda book.

![](foodpin.png)

## Some notes
see commit history for details.

### 基本操作1
1. change cell style from basic to custom.
2. change table view row height from default(44) to 80
3. change cell row height to 80 (只要勾上custom会自动变成80)
4. drag an image view to the cell (14,10) 60*60
5. Add 3 labels: Name(Headline), Location(Light, 14, Dark Gray), Type(Light, 13)
6. Stackview the 3 labels, spacing: 0 -> 1
7. Stackview the image and above stackview, spacing: 0 -> 10, Alignment: Top
8. 设置最外层的stack view 和cell边距的上左下右分别为2, 6, 1.5, 0这时stackview会填充整个cell, 但是图片被横向拉伸了
9. 在outline中ctrl水平拖动image view到自身, 设置width和height为60

### 基本操作2
1. 在outline的tableviewCell上点右键可以看到这个cell中定义的所有outlet
2. UIKit中所有View都自带CALayer, 这个layer对象可以控制view的背景色,边框, 透明度, 圆角


### 设置圆角:

```swift
cell.thumbnailImageView.layer.cornerRadius = 30.0
cell.thumbnailImageView.clipsToBounds = true                                                                                             
```
或者选中image view在identity inspector中新增一个runtime属性layer.cornerRadius值为Number:30
并在attributes inspector中勾选clip to bounds


### 自适应大小的cell
1. 将Value label的Lines从1改成0, 这样Label可以显示多行文字
2. tableView.estimatedHeight改成它的预计行高值(36/44), 以优化性能, 默认值是0
3. tableView.rowHeight = UITableViewAutomaticDimension, 从iOS10开始, 这已经是默认值
4. 这时console会有个layout warning, 解决办法是给这个cell中包含的那个stack view设置top和bottom约束(之前已经给它设定了leading/trailing和center vertically的约束,但是对于自适应大小的cell来说还不够)


### 美化tableview/表格线
```swiftv
//roration margin
self.tableView.cellLayoutMarginsFollowReadableWidth = true
// set table view bg color
tableView.backgroundColor = UIColor(white: 240.0/255, alpha: 0.2)
// remove empty rows
tableView.tableFooterView = UIView(frame: CGRect.zero)
//set separator color
tableView.separatorColor = UIColor(white: 240.0/255, alpha: 0.8)

```

## 美化nav bar
1) 在didFinishLaunchingWithOptions设置nav bar的背景色

```swift
//big title
self.navigationController?.navigationBar.prefersLargeTitles = true

// nav bar bg color
UINavigationBar.appearance().barTintColor = UIColor(red: 216.0/255, green: 74.0/255, blue: 32.0/255, alpha: 1.0)

// nav bar button style(可以点击的)
UINavigationBar.appearance().tintColor = UIColor.white

// nav title style
if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {

UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: barFont]
}
```
Navbar的背景色为UINavigationBar.appearance().barTintColor, 但是它还有一个backgroundColor属性,呃.

2) 在segue.source这边viewDidLoad中重新定义后退按钮(不带文字)

```swift
navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
```

3) 在detail view的viewDidLoad中设置nav bar title

```swift
title = restaurant.name
```
4) 全透明navigation bar
navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
navigationController?.navigationBar.shadowImage = UIImage()
navigationController?.navigationBar.isTranslucent = true

5) 全局修改nav bar返回导航图片
let backIndicator = UIImage(named: "back")
UINavigationBar.appearance().backIndicatorImage = backIndicator
UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIndicator


## 美化status bar
修改status bar黑色文字为白色, 两种方式:
1) ViewController逐个修改, 覆盖preferredStatusBarStyle方法即可(.lightContent), 如果当前的ViewController被嵌套在Navigation Controller中，
需要重载Navigation Controller中的preferredStatusBarStyle
 open override var preferredStatusBarStyle: UIStatusBarStyle{
    return topViewController?.preferredStatusBarStyle ?? .default
}

2) 全局修改
1. Info.plist设置`View controller-based status bar appearance=NO`
2. AppDelegate中`UIApplication.shared.statusBarStyle = .lightContent`




### 圆形button
1. title=blank, image=check, (type=system, tint=white设置按钮的颜色)
2. 点pin按钮,设置top=8,right=8,width=28,height=28

### 全屏背景
1. drag a new view controller
2. drag image view onto it, resize to full screen
3. add missing constraints, 但是Xcode8.1上这个选项是灰的, 最后用了reset to suggested constraints

### 半屏窗口
1. container view: drag a view object onto the image view(x=53, y=40, 269*420)

### 右上角关闭按钮
1. Drag a button(top=-13, right=-12, 28*28), title=blank, image=cross
2. 在前一屏中加入`@IBAction func close(segue: UIStoryboardSegue) {}`这句代码告诉Xcode这个viewController可以被unwind
3. Ctrl drag this close button to the exit button on this review scene, and select `closeWithSegue:`

### 让全屏背景模糊

在viewDidLoad中加入

```swift
let blurEffect = UIBlurEffect(style: .dark)
let blurEffectView = UIVisualEffectView(effect: blurEffect)
blurEffectView.frame = view.bounds
backgroundImageView.addSubview(blurEffectView)

```
就是给ImageView加上一个大小相同的subview, 上面代码中第三行view变量是所有UIViewController都有的, 表示这个ViewController管理的顶层view对象.

### Container view大小变换(scaleX)
怎么将view的大小变成0? 大小值用`CGAffineTransform`表示

1. 大小为0:CGAffineTransform(scaleX: 0, y: 0)
2. 原始大小及位置:CGAffineTransform.indentiy
3. 在viewDidLoad中将view的transform属性设置为0
4. 在viewDIdAppear中将view的transform属性设置为原始值.


简单动画

```swift
UIView.animate(withDuration: 0.3, animations: {
self.containerView.transform = CGAffineTransform.identity
})
```

Spring动画(UIView.animate多加些参数)

```swift
UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
self.containerView.transform = CGAffineTransform.identity
}, completion: nil)
```

### 组合变换scale + translate(viewDidLoad)

```swift
let scaleTransform = CGAffineTransform(scaleX: 0, y: 0)
let translateTransform = CGAffineTransform(translationX: 0, y: -1000)
let combineTransform = scaleTransform.concatenating(translateTransform)
containerView.transform = combineTransform
```

CGAffineTransform(translationX:y:)中的x, y都是相对于目标原始位置的偏移量, 并不是相对屏幕左上角.

### 3 more unwind segue(with identifier)
在detailViewController中加入`@IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {}`
分别拖动review界面上的三个评价按钮到exit button, 全部选择ratingButtonTappedWithSegue:, 这样在outline中会多出三个unwind segue, 设定它们的identifier为great/good/dislike


```swift
@IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
if let rating = segue.identifier {
restaurant.isVisited = true

switch rating {
case "great": restaurant.rating = "love it."
// ...
default: break
}
}

tableView.reloadData()
}
```

### Static Map
1. Switch ON map capability
2. Drag a map view onto the table view footer(height=135)
3. We want a static map, so untick all Allows(zooming, scrolling...)
4. That's all

### Fullscreen map
1. Drag a new view controller
2. Drag a new map view, resize it to be full-screen, add missing constraints
3. Ctrl drag from detail view controller to this newly created controller, segue.identifier=showMap(为什么不从static map拖到map view controller, 这是因为table header和footer都没法点击, 只能通过代码来打开新的view controller

### 给static map绑定tap事件
在detail view的viewDidLoad中

```swift
let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
mapView.addGestureRecognizer(tapGestureRecognizer)
```

performSegue以编程的方式触发transition.

```swift
func showMap(){
performSegue(withIdentifier: "showMap", sender: self)
}
```
注意是UITapGestureRecognizer而非UIGestureRecognizer.

### 地址转coordinate


地址转coordinate: 你输入一个文本地址, 地图服务器通常会返回一堆相似的地址, 这堆文本地址叫placemarks

```swift
let geoCoder = CLGeocoder()
geoCoder.geocodeAddressString(restaurant.location, completionHandler: {
placemarks, error in
let coordinate = placemarks?[0].location?.coordinate
})
```

在static map上标记位置.

```swift
// 搜索地址
let geoCoder = CLGeocoder()
geoCoder.geocodeAddressString("湖北省鄂州高中", completionHandler: {
placemarks, error in
if error != nil { print(error!); return }
// 地址转坐标
if let coordinate = placemarks?[0].location?.coordinate {
// 在那个位置显示一个pin
let annotation = MKPointAnnotation()
annotation.coordinate = coordinate
self.mapView.addAnnotation(annotation)

// 以那个pin为中心显示多大的区域, 半径250米
let region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250)
self.mapView.setRegion(region, animated: true)
}

})
```

显示多个pin, 并选择一个弹出气泡提示

```swift
if let coordinate = placemarks?[0].location?.coordinate {
let annotation = MKPointAnnotation()
annotation.coordinate = coordinate
annotation.title = "湖北省鄂州高中"
annotation.subtitle = "滨湖南路特一号"
//self.mapView.addAnnotation(annotation)
self.mapView.showAnnotations([annotation], animated: true)
self.mapView.selectAnnotation(annotation, animated: true)
}
```
和上面的代码区别很小(并且这种情况下map会选择最优region)

### NEW Form
1. 5 cells, rowHeight=250,72,72,72,72
2. image view (64*64) center
3. text field(placeholder, no border, width = 339)
4. select labels + text fields, add missing constraints
5. YES/NO buttons, color=white, bgColor=red/gray
6. Embed in navigation controller

### + -> NEW Form
1. NEW Form为什么要套在nav controller中?(是为了在左上角加上Cancel按钮)
2. Ctrl drag + 号到nav controller, 类型为Present Modally, identifier=addRestaurant
3. HomeController中写上`@IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {}`
4. New Form左上弄个Cancel按钮, 并拖到Exit button上新增unwind segue

### 打开ImagePicker
因为image view是放在第一个cell中. 只要实现didSelectRowAt, 并且在其中present系统内置的UIImagePickerController


```swift
if indexPath.row == 0 {
if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
let imagePicker = UIImagePickerController()
imagePicker.allowsEditing = false
imagePicker.sourceType = .photoLibrary

present(imagePicker, animated: true, completion: nil)
}
}

```

从iOS10开始, 需要在Info.plist中显示指定打开图库的理由, 以便得到用户允许.`Privacy - Photo Library Usage Description=就是要看!`

直接把`.photoLibrary`改成`.camera`可以拍照取图

### ImagePicker回调
ImagePicker的delegate必须同时满足两个接口:`UIImagePickerControllerDelegate, UINavigationControllerDelegate`
在didSelectRow中present前`imagePicker.delegate = self`, 然后实现下面这个回调函数即可
UIImagePickerControllerDelegate.didFinishPickingMediaWithInfo

```swift
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
photoImageView.image = selectedImage
photoImageView.contentMode = .scaleAspectFill
photoImageView.clipsToBounds = true
}

dismiss(animated: true, completion: nil)
}
```
在didSelectRowAt中present, 在这个回调中dismiss(这个dismiss是关闭从当前view controller中打开的modal对话框,并不是关闭自身)

### NSLayoutConstraint
A layout constraint defines a relationship between two user interface objects用公式表示:
`photoImageView.leading = superview.leading * 1 + 0`
用代码实现这个公式.

```swift
let leading = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
leading.isActive = true
```

### 关闭view controller两种办法

```swift
@IBAction func saveRestaurant() {
if checkForm() {
//dismiss(animated: true, completion: nil)
performSegue(withIdentifier: "unwindToHomeScreen", sender: self)

} else {
```
因为我想沿用Cancel按钮使用的unwind segue,在用第2种方法的时候碰到了找不到unwind segue identifier的问题, 参见[SO]解决: 虽然unwind segue的Action segue是根据你所定义的func名字生成的, 但是identifier还是需要自己指定.

### CoreData Data Model
新建一个Data Model: `FoodPinDemo.xcdatamodeld`, Entity改名为Restaurant, Class改名为RestaurantMO(这个Managed Object类编译项目会自动生成, project中看不到)

RestaurantMO所有属性都变成了optional, 并且image(binary)的类型为NSData.

主要变化

1. UIImage(named: restaurant.image) -> UIImage(data: restaurant.image as! Data)
2. resturant.location -> restaurant.location!
3. restaurant.rating -> restaurant.rating ?? ""

之前的Restaurant.swift废掉, 可以删除.

### CoreData CRUD
findAll, 在viewWillAppear中加入:

```swift
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let ctx = appDelegate.persistentContainer.viewContext
let request: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
let restaurants = try! ctx.fetch(request)
```

简单封装的工具类CD(save传的参数没有用到, 只是为了好看!):

```swift
class CD {

class var appDelegate: AppDelegate {
return UIApplication.shared.delegate as! AppDelegate
}
class var ctx: NSManagedObjectContext {
return appDelegate.persistentContainer.viewContext
}

class func delete<T: NSManagedObject>(_ o: T) {
ctx.delete(o)
save(o)
}

class func save(_ _: NSManagedObject) {
appDelegate.saveContext()
}

class func image2Data(image: UIImage?) -> NSData? {
if let image = image {
if let imageData = UIImagePNGRepresentation(image) {
return NSData(data: imageData)
}
}

return nil
}
```
这个类间歇性的报ambiguous use of x 的错误, 但是程序能正常运行, 怀疑是Xcode8.1的bug.

增删改查:

```swift
// create (AddRestaurantController)
let restaurant = RestaurantMO(context: CD.ctx)
restaurant.name = name
restaurant.type = type
restaurant.image = CD.image2Data(image: photoImageView.image)
CD.save(restaurant)

// delete (editActionsForRowAt)
let restaurant = restaurants.remove(at: indexPath.row)
tableView.deleteRows(at: [indexPath], with: .fade)
CD.delete(restaurant)

// update (ratingButtonTapped)
restaurant.isVisited = true
CD.save(restaurant)

// find all (viewWillAppear)
let request: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
restaurants = try! CD.ctx.fetch(request)
tableView.reloadData()
```
待研究: http://stackoverflow.com/questions/37810967/how-to-apply-the-type-to-a-nsfetchrequest-instance

### Search bar
以为是拖的, 没想到是在viewDidLoad中加两行代码

```swift
searchController = UISearchController(searchResultsController: nil)
tableView.tableHeaderView = searchController.searchBar
```

### 处理Search
1) 按套路是用delegate实现,然而并没有使用UISearchControllerDelegate,用的是UISearchResultsUpdating, 在viewDidLoad中加入

```swift
searchController.searchResultsUpdater = self
searchController.dimsBackgroundDuringPresentation = false
```
第二句是让search结果弹出时, 背景模糊(因为我们没有用单独的view来显示查询结果, 没有背景层, 在此设为false)

2) 处理search的回调函数: UISearchResultsUpdating.updateSearchResults(for:)

```swift
func updateSearchResults(for searchController: UISearchController) {
if let text = searchController.searchBar.text {
searchResults = restaurants.filter { restaurant -> Bool in
if let name = restaurant.name {
let isMatch = name.localizedCaseInsensitiveContains(text)
return isMatch
}

return false
}
tableView.reloadData()
}
}
```

3) 在先前用到restaurants的地方依情况选用searchResults, 包含numberOfRowsInSection, cellForRowAtIndexPath,  prepare(for:), 使用`searchController.isActive`判断当前是否处在search模式下.

4) 在Search时禁用Delete/Share功能

```swift
override func tableView(_:canEditRowAt:) -> Bool {
if searchController.isActive {
return false
}
return true
}
```
### 美化search bar
viewDidLoad设置前景色(Cancel按钮), 背景色.

```swift
let searchBar = searchController.searchBar
searchBar.placeholder = "Search restaurants..."
searchBar.tintColor = UIColor.white
searchBar.barTintColor = UIColor(red: 218.0/255, green: 100.0/255, blue: 70.0/255, alpha: 1.0)
tableView.tableHeaderView = searchBar
```

发现search bar上面会出现很丑的边框, 参考了作者的代码,发现作者和书中写的不一样, 最终选的灰色`searchBar.barTintColor = UIColor(white: 236.0/255, alpha: 1.0)`, 去掉边框的解决办法[参考这里][search_bar_border](未试)

### UIPageViewController(幻灯片)
UIPageViewController(我喜欢叫它Page Container)是多个View的容器(类似Navigation Controller), 用来管理它所包含的多个子view, 但是由于子view的相似性, 我们只用拖一个View Controller做为模版(我叫它Single Page).

#### 创建Page Container
1) 拖一个page view controller

2) Transition style从`Page Curl(翻书效果)`改成`Scroll`

3) Storyboard ID: PageContainer

4) 在list view的viewDidAppear中显示page container

```swift
func viewDidAppear() {
if let pageContainer = storyboard?.instantiateViewController(withIdentifier: "PageContainer") as? PageContainer {
present(pageContainer, animated: true, completion: nil)
}
}
```

5) 在page container的viewDidLoad中加载第一个page

6) 使用UIPageViewController.setViewControllers指定显示哪个page, 实现DataSource接口中的两个方法viewControllerBefore, viewControllerAfter设定向前和向后翻页时显示哪个page.

```swift
class PageContainer: UIPageViewController, UIPageViewControllerDataSource {

var pageHeadings = ["Personalize", "Locate", "Discover"]
var pageImages = ["foodpin-intro-1", "foodpin-intro-2", "foodpin-intro-3"]
var pageContent = ["content1","2","3"]

override func viewDidLoad() {
dataSource = self
if let startingPage = page(at: 0) {
setViewControllers([startingPage], direction: .forward, animated: true, completion: nil)
}
}

func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
var index = (viewController as! SinglePage).index
index -= 1

return page(at: index)
}

func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter
viewController: UIViewController) -> UIViewController? {
var index = (viewController as! SinglePage).index
index += 1

return page(at: index)

}

func page(at index: Int) -> SinglePage? {
if index < 0 || index >= pageHeadings.count {
return nil
}

if let page = storyboard?.instantiateViewController(withIdentifier: "SinglePage")  as? SinglePage{
page.imageFile = pageImages[index]
page.heading = pageHeadings[index]
page.content = pageContent[index]
page.index = index

return page
}

return nil
}

}
```


#### 定义Single Page模版
Single Page是一个简单的View Controller,在Page Container的page(at)方法中动态的创建设置各个属性值并做为viewControllerBefore的返回值.

1. Drag a view controller, view bgcolor=#c0392b
2. Label("Personalize")=top, hCenter
3. Image View(300*232)=Aspect Ratio
4. Label("Pin your ...",align=center, lines=0)=w282 h64
5. Storyboard ID = SinglePage
6. Set custom class, bind IBOutlets

```swift
class SinglePage: UIViewController {
@IBOutlet weak var headingLabel: UILabel!
@IBOutlet weak var contentLabel: UILabel!
@IBOutlet weak var contentImageView: UIImageView!

var index = 0
var heading = ""
var imageFile = ""
var content = ""

override func viewDidLoad() {
super.viewDidLoad()

headingLabel.text = heading
contentLabel.text = content
contentImageView.image = UIImage(named: imageFile)
}

}

```

### 幻灯片底部page indicator
在Page Container中实现UIPageViewControllerDataSource中的两个接口即可.

```swift
func presentationCount(for pageViewController: UIPageViewController) -> Int {
print("presentationCount: \(pageHeadings.count)")
return pageHeadings.count
}

func presentationIndex(for pageViewController: UIPageViewController) -> Int {
print("presentationIndex")

if let page = storyboard?.instantiateViewController(withIdentifier: "SinglePage")  as? SinglePage {
print("page index is: \(page.index)")
return page.index
}

print("no page found, return 0")
return 0
}
```
还不太理解两个方法的调用时机, 实测presentationIndex永远都是返回0, 感觉很诡异, 这两个方法造中出来indicator样式太丑,无视.

### 自定义的Page indicator
1. 拖一个page control到single page底部
2. 设置pages=3(默认值), add missing constraints, 设置outlet.
3. 在single Page的viewDidLoad中`pageControl.currentPage = index` 
4. That's all

### 幻灯片上的NEXT/DONE按钮
1) 拖个button到最右下角(bottom=7, right=0), 设置outlet

2) 在single page的viewDidLoad中动态修改按钮的文本

```swift
switch index {
case 0...1:
forwardButton.setTitle("NEXT", for: .normal)
case 2:
forwardButton.setTitle("DONE", for: .normal)
default:
break
}
```

3) 给NEXT按钮绑定点击事件


```swift
@IBAction func buttonTapped(_ sender: UIButton) {
switch index {
case 0...1:
let pageContainer = parent as! PageContainer
pageContainer.forward(index: index)
case 2:
dismiss(animated: true, completion: nil)
default:
break
}
}
``` 

4) PageContainer增加翻页的方法(forward)

```swift
func forward(index: Int) {
if let nextPage = page(at: index + 1) {
setViewControllers([nextPage], direction: .forward, animated: true, completion: nil)
}
}
```


### 仅展示一次幻灯片(UserDefaults)
在DONE按钮的点击事件中,存个值到UserDefaults中:
`UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")`

在列表页viewDidAppear中判断是否存过,存过直接返回: `if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {return}`

### Tab bar

1. 把initial navigation controller直接embed in tab bar controller, 然后先前的initial nav controller的底部就会多出一个tab bar item, 点击它, 并设置System item: Favorites, 就这么简单!

2. 在navigation controller内部非第1页的界面我们可以隐藏tab bar, 比如在detail view上要隐藏tab bar, 两种方式: 1)在IB中找到detail view勾选`Hide Bottom Bar on Push`; 2) 在列表页的prepare(for:)中加上`segue.destination.hidesBottomBarWhenPushed = true`


吐槽一下Xcode8.1: 在embed in tab bar以后, 好几个view报missing constraints的错误, 但是constraint一点问题都没有并且运行也正常.

### 创建新tab
1. 拖一个navigation controller到storyboard(会自动带出一个table view controller)修改它的navigation item title为Discover
2. 从Tab bar controller拖Ctrl Drag到新的nav controller选择`Relationship Segue: view controllers`
3. 修改tab bar item的类型为Recents
4. 如法炮制创建一个About tab.

### 美化Tab Bar
类似nav bar, 在didFinishLaunchingWithOptions中:

```swift
//前景色
UITabBar.appearance().tintColor = UIColor(red: 235.0/255, green: 75.0/255, blue: 27.0/255, alpha: 1.0)
//背景色
UITabBar.appearance().barTintColor = UIColor(red: 236.0/255, green: 240.0/255, blue: 241.0/255, alpha: 1.0)
//tab选中状态时的背景(默认无)
//UITabBar.appearance().selectionIndicatorImage = #imageLiteral(resourceName: "tabitem-selected")
```

改变tab item的文字和图片: Bar item设置title和image即可(此时System Item会自动变回Custom)

### 拆分Storyboard
正式的名称叫Storyboard References(Xcode7的新特性), 比较简单, 直接圈住从tab bar controller出发的指向discover nav controller的segue 顺流而下 一直到 discover table view controller, 然后选择`Editor > Refactor to storyboard...` 取名为`discover.storyboard`, 如法炮制提取`about.storyboard`.

### About page
打开about.storyboard

1. 拖image view到table view header(cell的上面), height=190, Content Mode=aspect fit, image=about-logo
2. Cell的style设置为Basic
3. 创建对应的AboutTableViewController(2 sections), 覆盖numberOfSections, numberOfRows, titleForHeaderInSection, cellForRowAt
4. 隐藏table footer:`tableView.tableFooterView=UIView(frame: CGRect.zero)`

```swift
class AboutTableViewController: UITableViewController {
var sectionTitles = ["",""]
var sectionContent = [["",""],["","",""]]
var links = ["","",""]

override func viewDidLoad() {
super.viewDidLoad()

tableView.tableFooterView = UIView(frame: CGRect.zero)
}
```

#### Open in Safari(Rate us)
didSelectRowAt中处理第1个Row的点击事件(用safari打开某个link)

```swift
func tableView(didSelectRowAt) {
switch (indexPath.section, indexPath.row) {
case (0,0):
if let url = URL(string: "http://www.apple.com/itunes/charts/paid-apps") {
UIApplication.shared.open(url)
}
default:
break
}
tableView.deselectRow(at: indexPath, animated: false)
}
```

#### WKWebView(iOS8及以上比UIWebView性能更好)
基本用法

```swift
let webView = WKWebVew()
webView.load(URLRequest(url: URL(string:"http://blabla"))
webView.load(URLRequest(url: URL(fileURLWithPath:"about.html")))

```

1. 拖一个新的view controller(空的, 之前以为要添加一个全屏的web view, 事实上什么也不用加)
2. 从About screen view controller Ctrl drag到这个新的View Controller(segue: Show, id: showWebView)
3. 设置对应的UIViewController类.


```swift
import WebKit

class WebViewController: UIViewController {
var webView: WKWebView!

override func viewDidLoad() {
super.viewDidLoad()

if let url = URL(string: "http://www.appcoda.com/contact") {
let request = URLRequest(url: url)
webView.load(request)
}
}

override func loadView() {
webView = WKWebView()
view = webView
}

}
```
其中loadView会在viewDidLoad之前被调用, 在这个方法中使用WKWebView替换掉View Controller自带的顶层view对象.

最后在About的didSelectRowAt, 在第2行点击的时候打开这个ViewController:` performSegue(withIdentifier: "showWebView", sender: self)`

从iOS9开始, Apple要求在后台只能打开HTTPS网站, 引入了` App Transport Security`(简称ATS), 在这里我们想打开http网站, 在Info.plist中禁用ATS: `ATS > Allow Arbitrary Loads = YES`

#### SFSafariViewController
内嵌Safari浏览器, 不用画任何界面, 直接present, 用法

```swift
import SafariServices

let svc = SFSafariViewController(url: url/*, entersReaderIfAvailable: true*/)
present(svc)
```

在About view controller的didSelectRowAt加上case(1,_)

```swift
func tableView(didSelectRowAt) {
switch (indexPath.section, indexPath.row) {
// open url
case (0,0):
if let url = URL(string: "http://www.apple.com/itunes/charts/paid-apps") {
UIApplication.shared.open(url)
}

// WKWebView
case (0,1):
performSegue(withIdentifier: "showWebView", sender: self)

// Embed safari browser
case (1,_):
if let url = URL(string: links[indexPath.row]) {
let svc = SFSafariViewController(url: url)
present(svc, animated: true, completion: nil)
}
default:
break
}
tableView.deselectRow(at: indexPath, animated: false)
}
```

### CloudKit
CloudKit需要开发者账号才能玩, $99 啊啊, 大出血.

在CloudKit中一个App对应一个Container, container中包含public, private, shared三种类型的DB, (shared是iOS10新增的类型), 所有安装了FoodPinDemo的用户都能访问public db(如果是写需要登录一次iCould), private只有用户自己能访问, shared只有group内的用户能访问(相当于QQ群), Db下分为Default Zone和Custom Zone, Zone下面是Record(一条条记录)

基本使用:

`Mobile端:` 在Capabilities中将CloudKit打开, services从Key-value storage改成CloudKit, Containers选择默认的Use default container (然后Xcode会自动到iCould上创建相应的container, 若有失败,可能是Bundle ID重复, 尝试换个Bundle ID)

`服务端:` 用**Safari浏览器**登录到apple dev center打开CloudKit Dashboard 在对应的Container中新建叫Restaurant的Record Type, 定义字段String(name,type,location,phone), Asset(image), 最后在Public Data - Default Zone中插入若干测试数据, 就能玩了..(CK中所有图片, 文件的类型都叫Asset), 然后可以使用傻瓜版的叫convenience API或高级版的叫operational API来抓或存数据. Convenience API没什么卵用, 即不能指定`select`也不能指定`where`.

#### 使用convenience API从iCould取数据
`var restaurants:[CKRecord] = []`并且在viewDidLoad中封装如下fetchRecordsFromCloud()

```swift
// Fetch data using Convenience API
let cloudContainer = CKContainer.default()
let publicDatabase = cloudContainer.publicCloudDatabase
let predicate = NSPredicate(value: true)
let query = CKQuery(recordType: "Restaurant", predicate: predicate)
publicDatabase.perform(query, inZoneWith: nil, completionHandler: {
(results, error) -> Void in
if error != nil {return}
if let results = results {
print("Completed the download of Restaurant data")
self.restaurants = results
self.tableView.reloadData()
} 
})
```

修改cellForRow

```swift
override func tableView(cellForRowAt) {
let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:
indexPath)
// Configure the cell...
let restaurant = restaurants[indexPath.row]
cell.textLabel?.text = restaurant.object(forKey: "name") as? String
if let image = restaurant.object(forKey: "image") {
let imageAsset = image as! CKAsset
if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
cell.imageView?.image = UIImage(data: imageData)
} 
}
return cell
```

CKRecord是key-value pair,. image是CKAsset类型. fileURL是CloudKit下载资源时的临时存储位置.publicDatabase.perform在抓数据是会新开一个后台线程, 在下载完成后reloadData()应该放在UI Thread中来完成, 因为OS会给bg thread很低的处理优先级, 即使数据下完了, tableView.reloadData()也不会立即执行, 解决办法见[swift3 concurrency][iOSConcurrency]: 

```swift
OperationQueue.main.addOperation {
self.tableView.reloadData()
}
```

#### 使用operational API
fetchRecordsFromCloud

```swift
let cloudContainer = CKContainer.default()
let publicDatabase = cloudContainer.publicCloudDatabase
// predicate指定空的where语句
let predicate = NSPredicate(value: true)
let query = CKQuery(recordType: "Restaurant", predicate: predicate)
// sortDescriptors按创建时间倒序排
query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending:
false)]
// Create the query operation with the query
let queryOperation = CKQueryOperation(query: query)
queryOperation.desiredKeys = ["name", "image"]
queryOperation.queuePriority = .veryHigh
queryOperation.resultsLimit = 50
queryOperation.recordFetchedBlock = { (record) -> Void in
self.restaurants.append(record)
}
queryOperation.queryCompletionBlock = { (cursor, error) -> Void in
if let error = error {
print("Failed to get data from iCloud - \
(error.localizedDescription)")
return
}
print("Successfully retrieve the data from iCloud")
OperationQueue.main.addOperation {
self.tableView.reloadData()
}
}
// Execute the query
publicDatabase.add(queryOperation)
```
desiredKeys指定select, resultsLimit指定limit, recordFetchedBlock是单条记录下载完成后的回调, queryCompletionBlock是所有记录下载完成后的回调.CKQueryCursor标记当前已经下载记录的位置(下次抓取时的起始位置), 可在分批下载数据时使用.

### 性能优化
分为real performance和perceived performance.

#### 1. 压缩图片大小
tinypng.com

#### 2. 使用`转圈圈`动画UIActivityIndicatorView

1) drag an Activity Indicator View object to the scene dock of the table view controller, 然后指定@IBOutlet

2) 这样和直接拖到view controller上没什么区别, 把它扔到边边上然后在viewDidLoad中指定它的实际位置就行.

```swift
@IBOutlet var spinner: UIActivityIndicatorView!
// viewDidLoad
spinner.hidesWhenStopped = true
spinner.center = view.center
tableView.addSubview(spinner)
spinner.startAnimating()
```

3) 在下载结束的回调函数中隐藏

```swift
OperationQueue.main.addOperation {
self.spinner.stopAnimating()
self.tableView.reloadData()
}
```

#### 3. 延迟下载图片
1. 查的时候只查name, 将`queryOperation.desiredKeys = ["name", "image"]`改成`queryOperation.desiredKeys = ["name"]`, 并给cell一个默认的图片, 这样可以实现秒加载
2. 在显示数据(cellForRowAt)的时候再去逐个下载图片

```swift
// Configure the cell...
let restaurant = restaurants[indexPath.row]
cell.textLabel?.text = restaurant.object(forKey: "name") as? String
// Set the default image
cell.imageView?.image = UIImage(named: "photoalbum")
// Fetch Image from Cloud in background
let publicDatabase = CKContainer.default().publicCloudDatabase
let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs:
[restaurant.recordID])
fetchRecordsImageOperation.desiredKeys = ["image"]
fetchRecordsImageOperation.queuePriority = .veryHigh
fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID,
error) -> Void in
if let error = error {
print("Failed to get restaurant image: \
(error.localizedDescription)")
return
}

if let restaurantRecord = record {
OperationQueue.main.addOperation() {
if let image = restaurantRecord.object(forKey: "image") {
let imageAsset = image as! CKAsset
if let imageData = try? Data.init(contentsOf:
imageAsset.fileURL) {
cell.imageView?.image = UIImage(data: imageData)
...


publicDatabase.add(fetchRecordsImageOperation)
return cell 
}
```
CKRecord中会自动包含recordID,用它来指定去下载哪条记录的image字段

#### 4. 缓存图片NSCache
在滑动表格的时候, cellForRowAt会不断被调用, 先前下载的图片每次都要重新下载, 使用NSCache来解决.

```swift
var imageCache = NSCache<CKRecordID, NSURL>()
```

因为图片下载后会被CloudKit缓存到fileURL指定的位置, 我们只要在NSCache中存这个文件的位置就行.

```swift
if let image = restaurantRecord.object(forKey: "image") {
let imageAsset = image as! CKAsset
if let imageData = try? Data.init(contentsOf:imageAsset.fileURL) {
cell.imageView?.image = UIImage(data: imageData)
// Add the image URL to cache
self.imageCache.setObject(imageAsset.fileURL as NSURL,forKey: restaurant.recordID)
```

### 下拉刷新Pull to refresh
超级简单, 所有的tableViewController自带refreshControl属性,只要给它指定一个值即可.(viewDidLoad)

```swift
// Pull To Refresh Control
refreshControl = UIRefreshControl()
refreshControl?.backgroundColor = UIColor.white
refreshControl?.tintColor = UIColor.gray
refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for:
UIControlEvents.valueChanged)
```
当下拉到一定程度的时候, ptr组件会触发UIControlEvent.valueChanged事件, 我们在上面的代码中监听这个事件, 指定回调函数就行(#selector是Xcode7.3/Swift2.2新增特性)

需要在刷新结束后隐藏ptr组件.

```swift
OperationQueue.main.addOperation {
self.spinner.stopAnimating()
self.tableView.reloadData()
if let refreshControl = self.refreshControl {
if refreshControl.isRefreshing {
refreshControl.endRefreshing()
}
}
}
```

在开始刷新数据前先清空旧数据.

```swift
func fetchRecordsFromCloud() {
// fix ptr bug
restaurants.removeAll()
tableView.reloadData()
```

### 向iCloud写数据
在添加界面除了用CoreData向本地写数据外, 同时往iCloud上的public db上写一份(共享给他人)
saveRecordToCloud(restaurant), 放在dismiss(animated:completion:)之前

```swift
import CloudKit 

func saveRecordToCloud(restaurant:RestaurantMO!) -> Void {
// Prepare the record to save
let record = CKRecord(recordType: "Restaurant")
record.setValue(restaurant.name, forKey: "name")
record.setValue(restaurant.type, forKey: "type")
record.setValue(restaurant.location, forKey: "location")
record.setValue(restaurant.phone, forKey: "phone")
let imageData = restaurant.image as! Data
// Resize the image
let originalImage = UIImage(data: imageData)!
let scalingFactor = (originalImage.size.width > 1024) ? 1024 /
originalImage.size.width : 1.0
let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
// Write the image to local file for temporary use
let imageFilePath = NSTemporaryDirectory() + restaurant.name!
let imageFileURL = URL(fileURLWithPath: imageFilePath)
try? UIImageJPEGRepresentation(scaledImage, 0.8)?.write(to: imageFileURL)
// Create image asset for upload
let imageAsset = CKAsset(fileURL: imageFileURL)
record.setValue(imageAsset, forKey: "image")
// Get the Public iCloud Database
let publicDatabase = CKContainer.default().publicCloudDatabase
// Save the record to iCloud
publicDatabase.save(record, completionHandler: { (record, error) -> Void in
// Remove temp file
try? FileManager.default.removeItem(at: imageFileURL)
})
```
对图片的处理稍显复杂: 先用UIImage对宽度超过1024的图片进行resize, 再用UIImageJPEGRepresentation将图片压缩并写入到临时文件夹NSTemporaryDirectory(), 然后再根据图片的地址构建CKAsset, 在save的回调函数中删除临时文件

### Keywords

1. 取选中行的行号: tableView.indexPathForSelectedRow
2. editActionsForRowAt
3. UITableViewRowAction
4. UIActivityViewController
5. prepare(for:sender:)
6. segue.destination/segue.identifier
7. UINavigationBar.appearance().barTintColor
8. UIApplication.shared.statusBarStyle
9. Dynamic Type - use a text style instead of a fixed font type.
10. CLGeocoder.geocodeAddressString
11. mapView.addAnnotation(MKPointAnnotation)
12. UIImagePickerController
13. NSLayoutConstraint(..).isActive
14. UIApplication.shared.delegate
15. NSData(data: UIImagePNGRepresentation(image))
16. UISearchResultsUpdating
17. String.localizedCaseInsensitiveContains
18. viewDidAppear: present(storyboard?.instantiateViewController(withIdentifier: "PageContainer") as? PageContainer)
19. PageContainer.setViewControllers([startingPage])
20. UIPageViewControllerDataSource.viewControllerBefore
21. storyboard?.instantiateViewController(withIdentifier: "SinglePage")  as? SinglePage
22. PageControl.currentPage = index
23. SinglePage中`let pageContainer = parent as! PageContainer`
24. UserDefaults.standard
25. UITabBar.appearance().tintColor
26. Refactor to storyboard...
27. UIApplication.shared.open(URL(string:))
28. WKWebView().load(URLRequest(url: URL(fileURLWithPath:"about.html")))
29. present(SFSafariViewController(url:))

### Omitted
1. Swipe to hide
2. MapKit: show image on callout bubble
3. NSFetchedResultsController
4. P393 Search bar延伸阅读

### Xcode tricks

1. How to switch between storyboard and swift file
>View > Show Tab Bar, create a new tab, for one tab, you can open storyboard, for the other, you can open the swift file, then you can use `shift+cmd+]` to switch between interface builder and source code file.

2. Interface builder: Zoom to fit
3. Can directly drag image from Finder to Simulator


[1]: http://stackoverflow.com/questions/19108513/uistatusbarstyle-preferredstatusbarstyle-does-not-work-on-ios-7
[SO]: http://stackoverflow.com/questions/27889645/performseguewithidentifier-has-no-segue-with-identifier
[search_bar_border]: http://stackoverflow.com/questions/19899642/remove-border-of-uisearchbar-in-ios7
[iosConcurrency]: https://github.com/uniquejava/iOSConcurrencyDemo


