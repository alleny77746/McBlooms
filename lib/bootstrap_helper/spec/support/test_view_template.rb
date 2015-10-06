class TestViewTemplate
  attr_accessor :output_buffer
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::CaptureHelper
end
