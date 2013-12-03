# GreaseMonkeyスクリプトの設定値に登録するIDのプレフィックス
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
    @$button = $('<a href="javascript:;;"</a>').css({
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
  visit : -> GM_setValue(prefix_id + @id, true)

  # 指定リンクを未読にします
  unvisit : -> GM_setValue(prefix_id + @id, false)

  # 指定リンクが既読かどうか
  isVisited : -> GM_getValue(prefix_id + @id, false)

# ランキングトップページで使用
class Watch_Top extends Watch
  #get_rank : -> parseInt(@$link.parents('.ranking_box').attr('id').replace('item', ''))
  select_box : -> @$link.parent().parent().parent()
  select_thumb : -> @$link.parent().parent().prev().find('img')
  select_useless : -> @$link.parent().siblings()

# ランキング各ジャンルページで使用
class Watch_Matrix extends Watch
  #get_rank : -> parseInt(@$link.parents('td.bg_grade_0').siblings('.rank_count').text())
  select_box : -> @$link.parent().parent()
  select_thumb : -> @$link.parent().prev().children().children().children()
  select_useless : -> @$link.parent().prev().prev()

# ジャンル別ランキングページで使用
class Watch_Fav extends Watch
  select_box : -> @$link.parent().parent().parent().parent().parent().parent().parent()
  select_thumb : -> @$link.parent().parent().parent().prev().find('img')
  select_useless : -> @$link.parent().siblings()

# 検索ページで使用
class Watch_Search extends Watch
  select_box : -> @$link.parent().parent()
  select_thumb : -> @$link.parent().prev().find('img')
  select_useless : -> @$link.parent().prev().find('table').next()

# 全ての動画アイテムのリスト
watches = (->
  if match 'matrix'
    $links = $('a.watch')
    page_type = Watch_Matrix
  else if match 'fav'
    $links = $('.content_672 a.watch')
    page_type = Watch_Fav
  else if (match 'search') || (match 'tag')
    $links = $('.content_672 a.watch')
    page_type = Watch_Search
  else
    $links = $('#ranking_main a.watch')
    page_type = Watch_Top
  $links.map((-> new page_type($(@))))
)()

console.log(watches)

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
  else if (match 'fav') || (match 'search') || (match 'tag')
    $('#mainContainer>table:last-child>tbody>tr>td:last-child')
      .before($('<td>').append $all_hide_button)
  else
    $('#ranking_main').append($all_hide_button)

# 初期化処理
init = ->
  check_all_watches()
  add_all_hide_button()

init()
