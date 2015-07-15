document.Cart = class Cart
  constructor: (el) ->
    @element = if el? then  $(el) else $("#cart")
    @grand_total = @element.find(".grand-total")
    @setupListeners()
  setupListeners: ->
    @element.on "change", ".quantity input.number", @update_total
    @element.on "blur", ".quantity input.number", @update_total
    @element.on "click", ".remove", @remove_item
  remove_item: (evt) =>
    evt.preventDefault()

    item = $($(evt.target).parents('.cart_item').first())
    console.log  item
    delete_field = item.find('input.destroy')

    options = {}
    if confirm("Are you sure you want to remove this from your basket?")
      if delete_field.length > 0
        item.addClass("removed")
        delete_field.val(true)
        item.hide(250)
      else
        alert("Unable to delete your item, please try clearning your basket")
      @compute_grand_total()

  update_total: (evt) =>
    target = $(evt.target)
    parent = target.parents('.cart_item')
    return unless parent?
    value = @get_number(parent.find(".price").text())
    total = value * target.val()
    parent.find(".total").text("$#{total.toFixed(2)}")
    @compute_grand_total()
  compute_grand_total: ->
    grand_total = 0
    for item in $(".cart_item .total")
      grand_total += parseFloat(@get_number($(item).text())) unless $(item).parent().hasClass("removed")

    @grand_total.text("$#{grand_total.toFixed(2)}")
  get_number: (value) ->
    value.replace(/([^\d\.])+/g, '')

document.AddressPrefill = class AddressPrefill
  constructor: (el) ->
    @page = $(el)
    @setupListeners()
  setupListeners: ->
    @page.on("click", ".address", @requestPrefill)
  requestPrefill:(evt) =>
    evt.preventDefault()
    target = $(evt.currentTarget)
    data = target.data("prefill") if target?
    if data?
      parent = target.parents("fieldset")
      return if parent.find(".street").val() != "" && !confirm("Are you sure you want to replace the current address?")
      for field, value of data
        parent.find(".#{field}").val(value);

document.SameAsBilling = class SameAsBilling
  constructor: (el) ->
    @page = $(el)
    @setupListeners()
  setupListeners: ->
    @page.on("click", ".same-as-billing", @copyBilling)
  copyBilling: (evt) =>
    evt.preventDefault()
    target = $(evt.currentTarget)
    billingTarget = target.parents(".addresses").find(".billing")
    shippingTarget = target.parents(".addresses").find(".shipping")
    return if shippingTarget.find(".street").val() != "" && !confirm("Are you sure you want to replace the current shipping address?")
    for field in ["street", "street2", "city", "province", "country", "postal_code"]
      shippingTarget.find("input.#{field}, select.#{field}").val(billingTarget.find("input.#{field}, select.#{field}").val())

jQuery ->
  cart = new Cart("#cart")
  addressPrefill = new AddressPrefill("#cart")
  sameAsBilling = new SameAsBilling("#cart")