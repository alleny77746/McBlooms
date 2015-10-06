shared_examples "an icon" do |icon_name|
  it "be an icon" do
    expect(subject).to have_icon(icon_name)
  end
end