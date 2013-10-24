#
# skill
#
class Skill
  
  constructor: ($el) ->
    @el = $el
    
    @skillId = $el.find('section').attr('data-skill')
    @sheet = $(".jobDetail section[data-skill=#{@skillId}]")
    
    @load()
    
    $el.find('label').each ->
      jobid = $(@).attr 'class'
      val = $(@).find('input[type=number]').val()
      #$i = $("<i class='#{jobid}' style='width:#{val}%' data-val='#{val}'>#{val}</i>")
      $i = $("<i class='#{jobid}' style='width:#{val}%' data-val='#{val}'></i>")
      $el.find('.chart.bar').append $i

    @el.find('input[type=number]').on 'change', (e)=>
      @.overCheck($(e.target))
      @.change($(e.target))
    
    @el.on 'click', =>
      @el.addClass('active').siblings('li').removeClass('active')
      @sheet.addClass('active').siblings('section').removeClass('active')
  
  change: ($input)->
    job = $input.attr('data-job')
    val = $input.val()
    @el.find('i.job'+job)
      #.text(val)
      .attr('data-val',val)
      .css(
        width: val+'%'
      )
    @sum = @getSum()
    @el.find('h1').attr('data-sum',@sum)
    @sheetUpdate()
    @save(job)
  
  overCheck: ($input)->
    sum = 0
    amari = 0
    $input.closest('div.input').find('input[type=number]').each ->
      sum += Number( $(@).val() )
    if sum > 100
      amari = sum - 100
    ans = $input.val() - amari
    $input.val(ans)
  
  getSum: ->
    sum = 0
    @el.find('label input').each (e)->
      sum += Number($(@).val())
    sum
  
  sheetUpdate: ->
    sum = @getSum()
    @sheet.find('.skillTable li .point').each ->
      cnt = Number( $(@).text() )
      if cnt <= sum
        $(@).closest('li').addClass('get')
      else
        $(@).closest('li').removeClass('get')
    
  save: (job)->
    data = @el.find("input[type=number][data-job=#{job}]").val()
    localStorage.setItem('dqxskillset?skill='+@skillId+'?job='+job, data)
  
  load: ->
    for i in [1...13]
      data = localStorage.getItem('dqxskillset?skill='+@skillId+'?job='+i)
      if data?
        @el.find("input[type=number][data-job=#{i}]").val(data)
    @sum = @getSum()
    @el.find('h1').attr('data-sum',@sum)
    @sheetUpdate()

#
# MAIN
#
$ ->
  $('.listSkill > li').each ->
    skill = new Skill $(@)
