import BaseResource from './base_resource'
import Tat from '../models/tat'

class TatsResource extends BaseResource
  @model = -> Tat

export default TatsResource
