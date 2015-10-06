shared_examples "a button" do |type|
  it "creates a link with a btn class" do
    expect(subject).to have_css("a.btn")
  end
  unless type.nil?
    it "creates a button of type #{type}" do
      expect(subject).to have_css("a.btn-#{type}")
    end
  end
end