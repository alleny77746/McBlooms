require "spec_helper"

describe AnlekBootstrapHelper::ModalHelper do
  let(:close_btn) { true }
  let(:title) { "MyTitle" }
  let(:body) { "<p>hello world!</p>".html_safe }
  let(:footer) { "<a>buttons</a>".html_safe }
  subject(:result) do
    helper.tb_modal do |m|
      m.header title
      m.body { body }
      m.footer { footer }
    end
  end
  it "works" do
    expected_html = <<-EOS
    <div aria-labelledby="modal" class="modal fade" role="dialog" tabindex="-1">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <button aria-hidden="true" class="close" data-dismiss="modal" type="button">&times;</button>
            <h4 class="modal-title">#{title}</h4>
          </div>
          <div class="modal-body">
            #{body}
          </div>
          <div class="modal-footer">
            #{footer}
          </div>
        </div>
      </div>
    </div>
    EOS

    expected_html = expected_html.gsub(/^\s+/, "").gsub("\n", "")

    expect(subject).to eq expected_html
  end
end
