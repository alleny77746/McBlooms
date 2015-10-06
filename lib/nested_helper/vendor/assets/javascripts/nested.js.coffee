 # Used to add/remove nested form items

@Nested = class Nested
  @add: (evt) ->
    evt.preventDefault()
    elm = $(evt.target)

    parent = $("##{elm.attr('rel')}")
    parent.append(Nested.template(elm))

    # Need to reset target here, above line doesn't return object
    target = $("##{elm.attr('rel')}").children().last().hide().slideDown()

    parent.trigger("nested:added", target)

  @remove: (evt) ->
    evt.preventDefault()
    elm = $(evt.target)

    item = elm.parents('.item').first()
    delete_field = $(item).find('input._delete')

    options = {}

    funct = undefined

    if delete_field.length > 0
      delete_field.val("1")
    else
      funct = item.remove.bind(item)

    item.hide(250, funct)

    item.parent().trigger("nested:removed", item)

  @template: (element) ->
    window["#{$("##{element.attr('rel')}").data('template')}"]
      .replace(/NEW_RECORD/g, new Date().getTime());


ready = ->
  $(".nested_set").on('click', ".add_nested_item", Nested.add)
  $(".nested_set").on('click', ".remove_nested_item", Nested.remove)

$(document).ready(ready)
$(document).on('page:load', ready)