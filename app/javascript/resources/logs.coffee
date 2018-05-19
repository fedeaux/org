import BaseResource from './base_resource'
import Log from '../models/log'

class LogsResource extends BaseResource
  @model = -> Log

export default LogsResource
