require "spec_helper"

describe AnlekBootstrapHelper::CrudButtonHelper do
  [User, [User.create, Report]].each do |object_data|
    let(:target_object) { Array.wrap(object).last }
    context "list_btn_for (with: #{object_data})" do
      let(:object){ object_data }
      subject(:result) { helper.list_btn_for(object) }
      it_behaves_like "a crud button", "list_btn_for", AnlekBootstrapHelper::CrudButtonHelper::STYLE[:list] do
        let(:default_name) { "Back to #{target_object.name.pluralize}" }
        let(:link) { url_for(object) }
      end
      it_behaves_like "a cancan enabled button", :read
    end

    context "new_btn_for (with: #{object_data})" do
      let(:object){ object_data }
      subject(:result) { helper.new_btn_for(object) }
      it_behaves_like "a crud button", "new_btn_for", AnlekBootstrapHelper::CrudButtonHelper::STYLE[:new] do
        let(:default_name) { "Add #{target_object.name}" }
        let(:link) { url_for(polymorphic_path(object, action: :new)) }
      end
      it_behaves_like "a cancan enabled button", :create
    end
  end

  [User.create, [User.create, Report.create]].each do |object_data|
    let(:object) { object_data }
    context "edit_btn_for (with: #{object_data})" do
      subject(:result) { helper.edit_btn_for(object) }
      it_behaves_like "a crud button", "edit_btn_for", AnlekBootstrapHelper::CrudButtonHelper::STYLE[:edit] do
        let(:default_name) { "Edit" }
        let(:link) { polymorphic_path(object, action: :edit) }
      end
      it_behaves_like "a cancan enabled button", :edit
    end

    context "delete_btn_for (with: #{object_data})" do
      subject(:result) { helper.delete_btn_for(object) }
      it_behaves_like "a crud button", "delete_btn_for", AnlekBootstrapHelper::CrudButtonHelper::STYLE[:delete] do
        let(:default_name) { "Remove" }
        let(:link) { polymorphic_path(object) }
      end

      it_behaves_like "a cancan enabled button", :delete
      context 'data-method' do
        it "exists" do
          expect(subject).to have_css("[data-method=DELETE]")
        end
        it "can be overwritten" do
          btn = helper.delete_btn_for(object, data: {method: "GET"})
          expect(btn).to have_css("[data-method=GET]")
        end
        it "can be overwritten even if passed outside of data" do
          method = "POST"
          btn = helper.delete_btn_for(object, method: "#{method}")
          expect(btn).to have_css("[data-method=#{method}]")
        end
      end
      context "data-confirm" do
        it "exists (by default)" do
          expect(subject).to have_css("[data-confirm='Are you sure?']")
        end
        it "can be overwritten" do
          confirm_msg = "Really?"
          btn = helper.delete_btn_for(object, data: {confirm: confirm_msg})
          expect(btn).to have_css("[data-confirm='#{confirm_msg}']")
        end
        it "can be overwritten even if passed outside of data" do
          confirm_msg = "Really?!"
          btn = helper.delete_btn_for(object, confirm: confirm_msg)
          expect(btn).to have_css("[data-confirm='#{confirm_msg}']")
        end
      end
    end
  end
end
