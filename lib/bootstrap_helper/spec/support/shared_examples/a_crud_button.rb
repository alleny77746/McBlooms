shared_examples "a crud button" do |method, default_style|
  let(:helper_method) { method }
  subject(:result) { helper.send(helper_method, object) }
  it_behaves_like "a button", default_style[:type]
  it_behaves_like "an icon", default_style[:icon]
  it "generates the correct link" do
    expect(subject).to have_css("a[href='#{link}']")
  end
  context 'label' do
    it "is defaulted" do
      expect(subject).to have_content(default_name)
    end
    it "can be overwritten" do
      new_name = "my button"
      btn = helper.send(helper_method, object, label: new_name)
      expect(btn).to have_content(new_name)
    end
  end
end
