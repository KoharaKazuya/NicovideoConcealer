# データベースのエントリに登録するIDのプレフィックス
prefix_id = 'visited_'

# ページの種類を判定する
match = (type) -> location.href.indexOf(type) != -1

# 一つの動画のアイテムを洗わすクラス
class Watch
  constructor : (@$link) ->
    @id = (=>
      @$link.attr('href').match(/watch\/([a-z0-9]+)/)
      RegExp.$1
    )()
    #@rank = @get_rank()
    @$box = @select_box()
    @$thumb = @select_thumb()
    @$useless = @select_useless()
    @$button = $('<a>').css({
      textDecoration: 'none'
      fontWeight: 'bold'
      fontSize: '12px'
      backgroundColor: 'white'
    }).text('[×]').bind('click', => @hide())
    (=>
      $field = $('<div></div>').css({
        textAlign: 'right'
        position: 'absolute'
        top: '0'
        right: '0'
      })
      @$box.css('position', 'relative')  # $button の position:absolute を正しく動作させるため
        .append($field.append(@$button))
    )()

  # 指定リンクを目立たせます。
  show : ->
    @$box.css('opacity', '1')
    @$thumb.css({
      width : '96px'
      height : '72px'
    })
    @$button
      .text('[×]')
      .bind('click', => @hide())
    @$useless.show()
    @unvisit()

  # 指定リンクを目立たなくします。
  hide : ->
    @$box.css('opacity', '0.5')
    @$thumb.css({
      width : '65px'
      height : '50px'
    })
    @$button
      .text('[○]')
      .bind('click', => @show())
    @$useless.hide()
    @visit()

  # 指定リンクを既読にします
  visit : -> localStorage.setItem(prefix_id + @id, true)

  # 指定リンクを未読にします
  unvisit : -> localStorage.setItem(prefix_id + @id, false)

  # 指定リンクが既読かどうか
  isVisited : -> localStorage.getItem(prefix_id + @id) || false

  select_box : -> @$link.parents('.item')
  select_thumb : -> @$link.parents('.item').find('.itemThumb')
  select_useless : -> @$link.parents('.item').find('.itemComment, .itemDescription, .itemData, .itemTime')

# 全ての動画アイテムのリスト
watches = $('.itemTitle a').map((-> new Watch($(@))))

# 全ての動画アイテムをそれぞれの既読/未読に従って表示を切り替える
check_all_watches = ->
  $.each(watches, ->
    @.hide() if @.isVisited()
  )

# 「全てを既読にする」のボタンを追加します
add_all_hide_button = ->
  $all_hide_button = $('<div />')
    .text('全て既読にする')
    .addClass('bg_grade_0')
    .css({
      width : 'auto'
      cursor : 'pointer'
      textAlign : 'center'
      fontSize: '30px'
    })
    .click(=> $.each(watches, -> @.hide()))
  if match 'matrix'
    $('.container table table tr:has(.otherContents)').empty().append(
      $('<td />')).append(
        $('<td colspan="11" />').append($all_hide_button)
      )
  else
    $('.contentBody>ul.list')
      .append($('<li>').append $all_hide_button)

# 初期化処理
init = ->
  check_all_watches()
  add_all_hide_button()

init()


# おまけ
$('.rankingPt').hide()
