// Generated by CoffeeScript 1.6.3
(function() {
  var Watch, add_all_hide_button, check_all_watches, init, match, prefix_id, watches;

  prefix_id = 'visited_';

  match = function(type) {
    return location.href.indexOf(type) !== -1;
  };

  Watch = (function() {
    function Watch($link) {
      var _this = this;
      this.$link = $link;
      this.id = (function() {
        _this.$link.attr('href').match(/watch\/([a-z0-9]+)/);
        return RegExp.$1;
      })();
      this.$box = this.select_box();
      this.$thumb = this.select_thumb();
      this.$useless = this.select_useless();
      this.$button = $('<a>').css({
        textDecoration: 'none',
        fontWeight: 'bold',
        fontSize: '12px',
        backgroundColor: 'white'
      }).text('[×]').bind('click', function() {
        return _this.hide();
      });
      (function() {
        var $field;
        $field = $('<div></div>').css({
          textAlign: 'right',
          position: 'absolute',
          top: '0',
          right: '0'
        });
        return _this.$box.css('position', 'relative').append($field.append(_this.$button));
      })();
    }

    Watch.prototype.show = function() {
      var _this = this;
      this.$box.css('opacity', '1');
      this.$thumb.css({
        width: '96px',
        height: '72px'
      });
      this.$button.text('[×]').bind('click', function() {
        return _this.hide();
      });
      this.$useless.show();
      return this.unvisit();
    };

    Watch.prototype.hide = function() {
      var _this = this;
      this.$box.css('opacity', '0.5');
      this.$thumb.css({
        width: '65px',
        height: '50px'
      });
      this.$button.text('[○]').bind('click', function() {
        return _this.show();
      });
      this.$useless.hide();
      return this.visit();
    };

    Watch.prototype.visit = function() {
      return localStorage.setItem(prefix_id + this.id, true);
    };

    Watch.prototype.unvisit = function() {
      return localStorage.setItem(prefix_id + this.id, false);
    };

    Watch.prototype.isVisited = function() {
      return localStorage.getItem(prefix_id + this.id) || false;
    };

    Watch.prototype.select_box = function() {
      return this.$link.parents('.item');
    };

    Watch.prototype.select_thumb = function() {
      return this.$link.parents('.item').find('.itemThumb');
    };

    Watch.prototype.select_useless = function() {
      return this.$link.parents('.item').find('.itemComment, .itemDescription, .itemData, .itemTime');
    };

    return Watch;

  })();

  watches = $('.itemTitle a').map((function() {
    return new Watch($(this));
  }));

  console.log(watches);

  check_all_watches = function() {
    return $.each(watches, function() {
      if (this.isVisited()) {
        return this.hide();
      }
    });
  };

  add_all_hide_button = function() {
    var $all_hide_button,
      _this = this;
    $all_hide_button = $('<div />').text('全て既読にする').addClass('bg_grade_0').css({
      width: 'auto',
      cursor: 'pointer',
      textAlign: 'center',
      fontSize: '30px'
    }).click(function() {
      return $.each(watches, function() {
        return this.hide();
      });
    });
    if (match('matrix')) {
      return $('.container table table tr:has(.otherContents)').empty().append($('<td />')).append($('<td colspan="11" />').append($all_hide_button));
    } else {
      return $('.contentBody>ul.list').append($('<li>').append($all_hide_button));
    }
  };

  init = function() {
    check_all_watches();
    return add_all_hide_button();
  };

  init();

  $('.rankingPt').hide();

}).call(this);
