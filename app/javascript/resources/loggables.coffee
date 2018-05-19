import BaseResource from './base_resource'
import Loggable from '../models/loggable'

class LoggablesResource extends BaseResource
  @model = -> Loggable

export default LoggablesResource
