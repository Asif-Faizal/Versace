abstract class CoreUseCase<Params, Result> {
  Future<Result> execute(Params params);
}

/// Use this when your use case doesn't need any parameters
class NoParams {
  const NoParams();
}

/// Use this when your use case doesn't return any value
class VoidResult {
  const VoidResult();
}

/// Use this when you need to pass multiple parameters
class UseCaseParams {
  final Map<String, dynamic> params;
  
  const UseCaseParams(this.params);
  
  dynamic operator [](String key) => params[key];
  
  bool containsKey(String key) => params.containsKey(key);
}

/// Use this when you need to return multiple values
class UseCaseResult {
  final Map<String, dynamic> data;
  
  const UseCaseResult(this.data);
  
  dynamic operator [](String key) => data[key];
  
  bool containsKey(String key) => data.containsKey(key);
} 