class CustomTrace {
  final StackTrace _trace;
  late String fileName;
  late String functionName;
  late String callerFunctionName;
  final String message;
  late int lineNumber;
  late int columnNumber;

  CustomTrace(this._trace, {required this.message}) {
    _parseTrace();
  }

  String _getFunctionNameFromFrame(String frame) {
    try {
      var currentTrace = frame;
      var indexOfWhiteSpace = currentTrace.indexOf(' ');
      if (indexOfWhiteSpace == -1) return "UnknownFunction";

      var subStr = currentTrace.substring(indexOfWhiteSpace).trim();
      var indexOfFunction = subStr.indexOf(RegExp(r'[A-Za-z0-9]'));

      if (indexOfFunction == -1) return "UnknownFunction";
      subStr = subStr.substring(indexOfFunction);

      indexOfWhiteSpace = subStr.indexOf(' ');
      if (indexOfWhiteSpace == -1) return subStr;

      return subStr.substring(0, indexOfWhiteSpace);
    } catch (e) {
      return "UnknownFunction";
    }
  }

  void _parseTrace() {
    try {
      var frames = _trace.toString().split("\n");

      functionName = frames.isNotEmpty ? _getFunctionNameFromFrame(frames[0]) : "UnknownFunction";
      callerFunctionName = frames.length > 1 ? _getFunctionNameFromFrame(frames[1]) : "UnknownCaller";

      var traceString = frames.isNotEmpty ? frames[0] : "UnknownTrace";
      var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));

      if (indexOfFileName != -1) {
        var fileInfo = traceString.substring(indexOfFileName);
        var listOfInfos = fileInfo.split(":");

        fileName = listOfInfos.isNotEmpty ? listOfInfos[0] : "UnknownFile";
        lineNumber = listOfInfos.length > 1 ? int.tryParse(listOfInfos[1]) ?? 0 : 0;
        columnNumber = listOfInfos.length > 2 ? int.tryParse(listOfInfos[2].replaceAll(")", "")) ?? 0 : 0;
      } else {
        fileName = "UnknownFile";
        lineNumber = 0;
        columnNumber = 0;
      }
    } catch (e) {
      fileName = "UnknownFile";
      functionName = "UnknownFunction";
      callerFunctionName = "UnknownCaller";
      lineNumber = 0;
      columnNumber = 0;
    }
  }

  @override
  String toString() {
    return "$message | File: $fileName | Line: $lineNumber | Function: $functionName";
  }
}
