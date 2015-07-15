require 'spec_helper'

describe User do
  subject(:user) { build :user }
  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_confirmation_of :password }
  it { is_expected.to validate_presence_of(:password).on(:create)}
  it { is_expected.to_not validate_presence_of(:password).on(:update)}

  it "has generated password and password_confirmation" do
    expect(subject.password).to_not be_blank
    expect(subject.password_confirmation).to_not be_blank
    expect(subject.password).to eq subject.password_confirmation
  end

  it "clears password and password_confirmation after <save></save>" do
    expect(subject.password).to_not be_blank
    expect(subject.password_confirmation).to_not be_blank
    subject.save
    expect(subject.password).to be_blank
    expect(subject.password_confirmation).to be_blank

  end


  it "has full_name" do
    u = build(:user, first_name: "John", last_name: "Smith")
    expect(u.name).to eq "John Smith"
  end

  context "generates password" do
    it "for a new user" do
      u = build(:user, password: "testpass", password_confirmation: "testpass")
      expect(u.crypted_password).to_not be_present
      expect(u.save).to be_truthy
      expect(u.crypted_password).to be_present
    end
    it "when password changes" do
      u = create(:user, password: "testpass", password_confirmation: "testpass")
      old_password = u.crypted_password
      u.password = u.password_confirmation = "newpassword"
      u.save
      expect(u.crypted_password).to_not eq old_password
    end
    it "only if password has changed" do
      u = create(:user, password: "testpass", password_confirmation: "testpass")
      old_password = u.crypted_password
      u.save
      expect(u.crypted_password).to eq old_password
    end
  end

  context "permission_collection" do
    it "has #{User::VALID_PERMISSIONS.count} permissions" do
      expect(User.permission_collection.count).to eq User::VALID_PERMISSIONS.count
    end
  end

  context "admin" do
    it do
      subject.permission = 99
      expect(subject).to be_admin
    end
    it "is not an admin if permission is below 99" do
      subject.permission = 98
      expect(subject).to_not be_admin
    end
  end

  context "distributor?" do
    it "is true if permission level is 20" do
      u = build(:user, permission: 20)
      expect(u.distributor?).to be_truthy
    end
    it "is false if permission level is 21" do
      u = build(:user, permission: 21)
      expect(u.distributor?).to_not be_truthy
    end
    it "is false if permission level is 10" do
      u = build(:user, permission: 10)
      expect(u.distributor?).to_not be_truthy
    end
  end

  context "consumer?" do
    it "is true if permission level is 10" do
      u = build(:user, permission: 10)
      expect(u.consumer?).to be_truthy
    end
    it "is true if permission level is 1" do
      u = build(:user, permission: 1)
      expect(u.consumer?).to be_truthy
    end
    it "is false if permission level is 20" do
      u = build(:user, permission: 20)
      expect(u.consumer?).to_not be_truthy
    end
    it "is false if permission level is 11" do
      u = build(:user, permission: 11)
      expect(u.consumer?).to_not be_truthy
    end
  end

  context "permission_name" do
    it "returns 'consumer' for new users" do
      expect(User.new.permission_name).to eq "consumer"
    end

    it "returns 'consumer' for user with permission 10" do
      expect(build(:consumer).permission_name).to eq "consumer"
    end

    it "returns 'distributor' for new users" do
      expect(build(:distributor).permission_name).to eq "distributor"
    end

    it "returns 'administrator' for new users" do
      expect(build(:admin).permission_name).to eq "administrator"
    end
  end

  describe "Addresses" do
    subject(:user) { create :user }
    let(:address1) { build :address, name: "address1" }
    let(:address2) { build :address, name: "address2" }
    let(:address3) { build :address, name: "address3" }

    it "can be saved" do
      subject.addresses = [address1, address2, address3]
      subject.save
      expect(subject.reload.addresses.count).to eq 3
    end

    context "default_address" do
      it "returns default address" do
        address2.default = true
        subject.addresses = [address1, address2, address3]
        subject.save
        expect(subject.default_address).to eq address2
      end
    end

  end
end
