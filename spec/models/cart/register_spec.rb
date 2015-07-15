describe Cart::Register do
  class CartRegisterObject
    include ActiveModel::Model
    include Cart::Register

    attr_accessor :user
  end

  let(:user) { create :user }
  subject(:cart) { CartRegisterObject.new(user: Object.new) }

  it { is_expected.to be_valid }

  context "checking_out" do
    it "false by default" do
      expect(subject.checking_out).to_not be_truthy
    end
    it "sets to trun on checking_out!" do
      subject.checking_out!
      expect(subject.checking_out).to be_truthy
    end
  end

  describe "without a user" do
    before(:each) do
      subject.checking_out!
      subject.user = nil
      subject.email = "steve@jobs.com"
      subject.password = subject.password_confirmation = 'mySecret'
    end

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_confirmation_of :password }
    context "email" do
      it "is valid" do
        subject.email = "john@doe.com"
        expect(subject).to be_valid
      end
      it "is invalid when not an email" do
        subject.email = "john@doe"
        expect(subject).to_not be_valid
      end

      it "validates uniqueness" do
        email = 'john@doe.com'
        user1 = create :user, email: email
        subject.email = email
        expect(subject).to_not be_valid
        expect(subject.errors).to include :email
      end
    end

    describe "register_user!" do
      before(:each) do
        subject.checking_out!
        subject.email = "john@doe.com"
        subject.password = subject.password_confirmation = "password"
      end
      it "generates a user record" do
        expect{subject.register_user!}.to change(User, :count).by(1)
      end
      it "attaches the user to the cart" do
        user = subject.register_user!
        expect(subject.user).to_not be_nil
        expect(subject.user).to eq user
      end
      it "fails on invalid user" do
        subject.email = "john@doe"
        expect{subject.register_user!}.to change(User, :count).by(0)
      end
      it "fails even if not checking out" do
        subject.checking_out = false
        subject.email = "john@doe"
        expect{subject.register_user!}.to change(User, :count).by(0)
      end

      it "doesn't generate user if cart already has a user" do
        subject.user = user
        expect{subject.register_user!}.to change(User, :count).by(0)
      end
    end
  end

  describe "with user" do
    before(:each) do
      subject.checking_out!
      subject.user = user
    end
    it "is valid" do
      expect(subject).to be_valid
    end
  end

  describe "while not checking out" do
    before(:each) do
      subject.checking_out = false
    end
    it "no validations run for registration data" do
      subject.user = nil
      subject.checking_out!
      expect(subject).to_not be_valid
      subject.checking_out = false
      expect(subject).to be_valid
    end
  end
end