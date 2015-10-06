require "anlek_bootstrap_helper/engine"
require "anlek_bootstrap_helper/util"
require "anlek_bootstrap_helper/renderers"

module AnlekBootstrapHelper
  def self.using_cancan?
    Object.const_defined?(:CanCan)
  end
end
