import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:wananzhuo/common/api.dart';
import 'package:path_provider/path_provider.dart';  


class HttpUtil {
  static HttpUtil? instance;
  late Dio dio;
  late BaseOptions options;

   CancelToken cancelToken = CancelToken();

   static HttpUtil getInstance(){
    instance ??= HttpUtil();
    return instance!;
   }
   HttpUtil(){
    options = BaseOptions(
      baseUrl: Api.BASE_URL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        "version": "1.0.0",
        
      },
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.plain
    );

    dio = Dio(options);

    final cookieJar = CookieJar();
    // final co = getAppDocsDir();
    // final cookieJar = PersistCookieJar(ignoreExpires: true,storage: FileStorage(co.toString() + "/.cookies/"));

    dio.interceptors.add(CookieManager(cookieJar));
    print('返回的cookieJar--------------${cookieJar.loadForRequest(Uri.parse(Api.BASE_URL)).then((value) => print(value))}');
    // print(Uri.base);
    print('请求之后options-----------${options.headers}');

    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler){

       print("请求之前 header = ${options.headers.toString()}");
       return handler.next(options);
    },
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      print("响应之前");
      // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
      return handler.next(response); // continue
    }, onError: (DioException e, ErrorInterceptorHandler handler) {
      print("错误之前");
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      return handler.next(e);
    }));
   }



  get(url,{data,options,cancelToken}) async {
   late Response response;

    try {
      response = await dio.get(url,queryParameters: data,options: options,cancelToken: cancelToken);
      print('get success---------${response.statusCode}');
      print('get success---------${response.data}');
    } on DioException catch (e) {
      print('get error---------$e');
      formatError(e);
    }
    return response;
    
  }
  

  post(url, {data, options, cancelToken}) async {
   late  Response response;
    try {
      response = await dio.post(url, queryParameters: data, options: options, cancelToken: cancelToken);
      print('post success---------${response.data}');
      print('post success---------headers内容:${response.headers}');
      print('post success---------headers内容:${response.requestOptions}');
      print('post success---------headers内容:${response.realUri}');
    } on DioException catch (e) {
      print('post error---------$e');
      formatError(e);
    }
    return response;
  }


  downloadFile(urlPath, savePath) async {
   late  Response response;
    try {
      response = await dio.download(urlPath, savePath, onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioException catch (e) {
      print('downloadFile error---------$e');
      formatError(e);
    }
    return response.data;
  }


  void formatError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioExceptionType.sendTimeout) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      //It occurs when receiving timeout
      print("响应超时");
    } else if (e.type == DioExceptionType.badResponse) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
    } else if (e.type == DioExceptionType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioException.error if it is not null.
      print("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
Future<String> getAppDocsDir() async {  
  final directory = await getApplicationDocumentsDirectory();  
  print('该方法执行');
  return directory.path;  
}  
}










