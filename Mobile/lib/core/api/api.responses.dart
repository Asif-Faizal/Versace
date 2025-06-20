enum ApiResponse {
  success(200),
  created(201),
  badRequest(400),
  unauthorized(401),
  forbidden(403),
  notFound(404),
  validationError(422),
  conflict(409),
  tooManyRequests(429),
  internalServerError(500),
  badGateway(502),
  serviceUnavailable(503),
  gatewayTimeout(504);

  final int value;
  const ApiResponse(this.value);
}