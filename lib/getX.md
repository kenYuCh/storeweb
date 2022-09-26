import 'package:get/get.dart';

// Provider
```dart
//------------------------------\]jhgfZxcvbnm,./]-----------------------------------------------
class Controller extends GetxController {
  //為了使其可觀察，您只需在其末尾添加“.obs”：
  var name = 'Jonatas Borges'.obs;

}


//在 UI 中，當您想要顯示該值並在值更改時更新屏幕時，只需執行以下操作：
Obx(() => Text("${controller.name}"));
//-----------------------------------------------------------------------------
// Route 管理
GetMaterialApp( // Before: MaterialApp(
  home: MyHome(),
)
//-----------------------------------------------------------------------------
// 導航到新頁面
Get.to(NextScreen());
// 導航到帶有名稱的新頁面
Get.toNamed('/details');
// 關閉snackbars、dialogs、bottomsheets或任何你通常會用Navigator.pop(context)關閉的東西；
Get.back();


// 轉到下一個屏幕並且沒有返回上一個屏幕的選項（用於 SplashScreens、登錄屏幕等）
Get.off(NextScreen());

// 轉到下一個屏幕並取消所有先前的路線（在購物車、投票和測試中很有用）
Get.offAll(NextScreen());

//-----------------------------------------------------------------------------

// 依賴管理器
// 這將使其在您的整個應用程序中可用。所以你可以正常使用你的控制器
Controller controller = Get.put(Controller());
// 如果您的應用程序已經在使用狀態管理器（任何一個都沒有關係），您不需要全部重寫，您可以使用這個依賴注入完全沒有問題
controller.fetchApi();

// 您已經瀏覽了許多路線，並且您需要留在控制器中的數據，您需要結合 Provider 或 Get_it 的狀態管理器，對嗎？不使用 Get。您只需要讓 Get 為您的控制器“查找”，您不需要任何額外的依賴項：
Controller controller = Get.find();
// 然後您將能夠恢復從那裡獲得的控制器數據：
Text(controller.textFromApi);



//-----------------------------------------------------------------------------
//獲取連接
// GetConnect 是一種使用 http 或 websockets 從後到前進行通信的簡單方法
// 您可以簡單地擴展 GetConnect 並使用 GET/POST/PUT/DELETE/SOCKET 方法與您的 Rest API 或 websocket 進行通信。

// default
class UserProvider extends GetConnect {
  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post request
  Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
  // Post request with File
  Future<Response<CasesModel>> postCases(List<int> image) {
    final form = FormData({
      'file': MultipartFile(image, filename: 'avatar.png'),
      'otherFile': MultipartFile(image, filename: 'cover.png'),
    });
    return post('http://youapi/users/upload', form);
  }

  GetSocket userMessages() {
    return socket('https://yourapi/users/socket');
  }
}

// Custom
class HomeProvider extends GetConnect {
  @override
  void onInit() {
    // All request will pass to jsonEncode so CasesModel.fromJson()
    httpClient.defaultDecoder = CasesModel.fromJson;
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; // It define baseUrl to
    // Http and websockets if used with no [httpClient] instance

    // It's will attach 'apikey' property on header from all requests
    httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });

    // Even if the server sends data from the country "Brazil",
    // it will never be displayed to users, because you remove
    // that data from the response, even before the response is delivered
    httpClient.addResponseModifier<CasesModel>((request, response) {
      CasesModel model = response.body;
      if (model.countries.contains('Brazil')) {
        model.countries.remove('Brazilll');
      }
    });

    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // Set the header
      request.headers['Authorization'] = "$token";
      return request;
    });

    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }
  }

  @override
  Future<Response<CasesModel>> getCases(String path) => get(path);
}

//-----------------------------------------------------------------------------
// 優先權
// GetPage 中間件: 這些中間件將按以下順序運行-8 => 2 => 4 => 5
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
// 當正在搜索被調用路由的頁面時，將調用該函數。它需要 RouteSettings 作為重定向到的結果。或者給它 null 並且不會有重定向。
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}


// onPageCalled 在創建任何內容之前調用此頁面時將調用此函數，您可以使用它來更改頁面的某些內容或為其提供新頁面
GetPage onPageCalled(GetPage page) {
  final authService = Get.find<AuthService>();
  return page.copyWith(title: 'Welcome ${authService.UserName}');
}

// OnBindingsStart 這個函數將在綁定初始化之前被調用。在這裡您可以更改此頁面的綁定。
List<Bindings> onBindingsStart(List<Bindings> bindings) {
  final authService = Get.find<AuthService>();
  if (authService.isAdmin) {
    bindings.add(AdminBinding());
  }
  return bindings;
}

// OnPageBuildStart 此函數將在綁定初始化後立即調用。在這裡，您可以在創建綁定之後和創建頁面小部件之前執行一些操作。
GetPageBuilder onPageBuildStart(GetPageBuilder page) {
  print('bindings are ready');
  return page;
}

// OnPageBuilt 該函數將在調用 GetPage.page 函數後立即調用，並為您提供函數的結果。並獲取將顯示的小部件。
// OnPageDispose 此函數將在處理完頁面的所有相關對象（控制器、視圖等）後立即調用。






//-----------------------------------------------------------------------------

// give the current args from currentScreen
Get.arguments

// give name of previous route
Get.previousRoute

// give the raw route to access for example, rawRoute.isFirst()
Get.rawRoute

// give access to Routing API from GetObserver
Get.routing

// check if snackbar is open
Get.isSnackbarOpen

// check if dialog is open
Get.isDialogOpen

// check if bottomsheet is open
Get.isBottomSheetOpen

// remove one route.
Get.removeRoute()

// back repeatedly until the predicate returns true.
Get.until()

// go to next route and remove all the previous routes until the predicate returns true.
Get.offUntil()

// go to next named route and remove all the previous routes until the predicate returns true.
Get.offNamedUntil()

//Check in what platform the app is running
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

//Check the device type
GetPlatform.isMobile
GetPlatform.isDesktop
//All platforms are supported independently in web!
//You can tell if you are running inside a browser
//on Windows, iOS, OSX, Android, etc.
GetPlatform.isWeb


// Equivalent to : MediaQuery.of(context).size.height,
// but immutable.
Get.height
Get.width

// Gives the current context of the Navigator.
Get.context

// Gives the context of the snackbar/dialog/bottomsheet in the foreground, anywhere in your code.
Get.contextOverlay

// Note: the following methods are extensions on context. Since you
// have access to context in any place of your UI, you can use it anywhere in the UI code

// If you need a changeable height/width (like Desktop or browser windows that can be scaled) you will need to use context.
context.width
context.height

// Gives you the power to define half the screen, a third of it and so on.
// Useful for responsive applications.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// Similar to MediaQuery.of(context).size
context.mediaQuerySize()

/// Similar to MediaQuery.of(context).padding
context.mediaQueryPadding()

/// Similar to MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// Similar to MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// Similar to MediaQuery.of(context).orientation;
context.orientation()

/// Check if device is on landscape mode
context.isLandscape()

/// Check if device is on portrait mode
context.isPortrait()

/// Similar to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// Similar to MediaQuery.of(context).textScaleFactor;
context.textScaleFactor()

/// Get the shortestSide from screen
context.mediaQueryShortestSide()

/// True if width be larger than 800
context.showNavbar()

/// True if the shortestSide is smaller than 600p
context.isPhone()

/// True if the shortestSide is largest than 600p
context.isSmallTablet()

/// True if the shortestSide is largest than 720p
context.isLargeTablet()

/// True if the current device is Tablet
context.isTablet()

/// Returns a value<T> according to the screen size
/// can give value for:
/// watch: if the shortestSide is smaller than 300
/// mobile: if the shortestSide is smaller than 600
/// tablet: if the shortestSide is smaller than 1200
/// desktop: if width is largest than 1200
context.responsiveValue<T>()



//-----------------------------------------------------------------------------

// 可選的全局設置和手動配置
// GetMaterialApp 為您配置一切，但如果您想手動配置 Get。
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [GetObserver()],
);

// 您還可以在內部使用自己的中間件 GetObserver，這不會影響任何事情。
MaterialApp(
  navigatorKey: Get.key,
  navigatorObservers: [
    GetObserver(MiddleWare.observer) // Here
  ],
);

// 您可以為Get. Get.config只需在推送任何路線之前添加到您的代碼中。或者直接在你的GetMaterialApp
GetMaterialApp(
  enableLog: true,
  defaultTransition: Transition.fade,
  opaqueRoute: Get.isOpaqueRouteDefault,
  popGesture: Get.isPopGestureEnable,
  transitionDuration: Get.defaultDurationTransition,
  defaultGlobalState: Get.defaultGlobalState,
);

Get.config(
  enableLog = true,
  defaultPopGesture = true,
  defaultTransition = Transitions.cupertino
)

// 您可以選擇將所有日誌消息從Get. 如果您想使用自己喜歡的日誌記錄包，並想在那裡捕獲日誌：
GetMaterialApp(
  enableLog: true,
  logWriterCallback: localLogWriter,
);
void localLogWriter(String text, {bool isError = false}) {
  // pass the message to your favourite logging package here
  // please note that even if enableLog: false log messages will be pushed in this callback
  // you get check the flag if you want through GetConfig.isLogEnable
}




//-----------------------------------------------------------------------------


// 使用更新後的值的回調可以簡化StatefulWidget這一點。.setState

ValueBuilder<bool>(
  initialValue: false,
  builder: (value, updateFn) => Switch(
    value: value,
    onChanged: updateFn, // same signature! you could use ( newValue ) => updateFn( newValue )
  ),
  // if you need to call something outside the builder method.
  onUpdate: (value) => print("Value updated: $value"),
  onDispose: () => print("Widget unmounted"),
),

// 類似於ValueBuilder，但這是 Reactive 版本，您傳遞一個 Rx 實例（還記得神奇的 .obs 嗎？）並自動更新......不是很棒嗎？

ObxValue((data) => Switch(
        value: data.value,
        // Rx has a _callable_ function! You could use (flag) => data.value = flag,
        onChanged: data, 
    ),
    false.obs,
),




//-----------------------------------------------------------------------------
// 有用的提示
// .observables（也稱為Rx類型）具有多種內部方法和運算符。

final name = 'GetX'.obs;
// only "updates" the stream, if the value is different from the current one.
name.value = 'Hey';

// All Rx properties are "callable" and returns the new value.
// but this approach does not accepts `null`, the UI will not rebuild.
name('Hello');

// is like a getter, prints 'Hello'.
name() ;

/// numbers:

final count = 0.obs;

// You can use all non mutable operations from num primitives!
count + 1;

// Watch out! this is only valid if `count` is not final, but var
count += 1;

// You can also compare against values:
count > 2;

/// booleans:

final flag = false.obs;

// switches the value between true/false
flag.toggle();


/// all types:

// Sets the `value` to null.
flag.nil();

// All toString(), toJson() operations are passed down to the `value`
print( count ); // calls `toString()` inside  for RxInt

final abc = [0,1,2].obs;
// Converts the value to a json Array, prints RxList
// Json is supported by all Rx types!
print('json: ${jsonEncode(abc)}, type: ${abc.runtimeType}');

// RxMap, RxList and RxSet are special Rx types, that extends their native types.
// but you can work with a List as a regular list, although is reactive!
abc.add(12); // pushes 12 to the list, and UPDATES the stream.
abc[3]; // like Lists, reads the index 3.


// equality works with the Rx and the value, but hashCode is always taken from the value
final number = 12.obs;
print( number == 12 ); // prints > true

/// Custom Rx Models:

// toJson(), toString() are deferred to the child, so you can implement override on them, and print() the observable directly.

class User {
    String name, last;
    int age;
    User({this.name, this.last, this.age});

    @override
    String toString() => '$name $last, $age years old';
}

final user = User(name: 'John', last: 'Doe', age: 33).obs;

// `user` is "reactive", but the properties inside ARE NOT!
// So, if we change some variable inside of it...
user.value.name = 'Roi';
// The widget will not rebuild!,
// `Rx` don't have any clue when you change something inside user.
// So, for custom classes, we need to manually "notify" the change.
user.refresh();

// or we can use the `update()` method!
user.update((value){
  value.name='Roi';
});

print( user );

//-----------------------------------------------------------------------------
// 狀態混合
// 另一種處理UI狀態的方法是使用StateMixin<T>. 要實現它，請使用 將with添加StateMixin<T> 到允許 T 模型的控制器中。
class Controller extends GetController with StateMixin<User>{}

RxStatus.loading();
RxStatus.success();
RxStatus.empty();
RxStatus.error('message');



class OtherClass extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: controller.obx(
        (state)=>Text(state.name),
        
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),

        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error)=>Text(error),
      ),
    );
}


//-----------------------------------------------------------------------------
// 獲取視圖
// 是一個有一個 getter 的 const StatelessWidget ，僅此而已。controllerController

 class AwesomeController extends GetController {
   final String title = 'My Awesome View';
 }

  // ALWAYS remember to pass the `Type` you used to register your controller!
 class AwesomeView extends GetView<AwesomeController> {
   @override
   Widget build(BuildContext context) {
     return Container(
       padding: EdgeInsets.all(20),
       child: Text(controller.title), // just call `controller.something`
     );
   }
 }

//-----------------------------------------------------------------------------

// 獲取服務
// 讓您的“服務”始終可以訪問和使用Get.find(). 比如： ApiService, StorageService, CacheService

Future<void> main() async {
  await initServices(); /// AWAIT SERVICES INITIALIZATION.
  runApp(SomeApp());
}

/// Is a smart move to make your Services intiialize before you run the Flutter app.
/// as you can control the execution flow (maybe you need to load some Theme configuration,
/// apiKey, language defined by the User... so load SettingService before running ApiService.
/// so GetMaterialApp() doesnt have to rebuild, and takes the values directly.
void initServices() async {
  print('starting services ...');
  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.
  await Get.putAsync(() => DbService().init());
  await Get.putAsync(SettingsService()).init();
  print('All services started...');
}

class DbService extends GetxService {
  Future<DbService> init() async {
    print('$runtimeType delays 2 sec');
    await 2.delay();
    print('$runtimeType ready!');
    return this;
  }
}

class SettingsService extends GetxService {
  void init() async {
    print('$runtimeType delays 1 sec');
    await 1.delay();
    print('$runtimeType ready!');
  }
}
// GetxService 實際刪除,的唯一方法Get.reset()就像是應用程序的“熱重啟”。所以請記住，如果您需要在應用程序的生命週期內絕對持久化一個類實例，請使用GetxService.


//-----------------------------------------------------------------------------






//-----------------------------------------------------------------------------




//-----------------------------------------------------------------------------





//-----------------------------------------------------------------------------












































































































































































































































































```