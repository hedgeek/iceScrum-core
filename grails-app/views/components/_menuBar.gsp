%{--
- Copyright (c) 2010 iceScrum Technologies.
-
- This file is part of iceScrum.
-
- iceScrum is free software: you can redistribute it and/or modify
- it under the terms of the GNU Lesser General Public License as published by
- the Free Software Foundation, either version 3 of the License.
-
- iceScrum is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU Lesser General Public License
- along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
-
- Authors:
-
- Vincent Barrier (vbarrier@kagilum.com)
- Damien vitrac (damien@oocube.com)
  --}%
  <g:each in="${menuElements}" var="menuElement" status="index">
    <is:menuElement title="${menuElement.title}" draggable="true" id="${menuElement.id}" widgetable="${menuElement.widgetable}"/>
    <is:shortcut key="ctrl+shift+${menuElement.position}" callback="\$(\$('#navigation .menubar')[${menuElement.position.toInteger() - 1}]).click();"/>
  </g:each>
  <sec:ifLoggedIn>
    <li class="navigation-line" id="menubar-list-button" style="visibility:${menuElementsHiddden?'visible':'hidden'}">
      <div class="dropmenu" id="menubar-list" data-dropmenu="true" data-autoClick="false">
        <a class="button-s clearfix">
          <span class="start"></span>
          <span class="content">
            <span class="arrow"></span>
          </span>
          <span class="end"></span>
        </a>
        <div class="dropmenu-content ui-corner-all" id="menubar-list-content">
          <ul>
            <g:each in="${menuElementsHiddden}" var="menuElementHidden">
              <is:menuElement title="${menuElementHidden.title}" draggable="true" hidden="${true}"  id="${menuElementHidden.id}" widgetable="${menuElementHidden.widgetable}"/>
              <is:shortcut key="ctrl+shift+${menuElementHidden.position}" callback="\$(\$('#navigation .menubar')[${menuElementHidden.position.toInteger() - 1}]).click();"/>
            </g:each>
          </ul>
        </div>
      </div>
    </li>
    <jq:jquery>
    $(".navigation-content:first").sortable({
        connectWith:'.widget-bar #menubar-list-button',
        revert:true,
        helper: 'clone',
        delay: 100,
        items: '.menubar',
        stop:function(event,ui){
          if ($('#menubar-list-content > ul .menubar').size() > 0){
            $('#menubar-list-button').css('visibility','visible');
          }else{
            $('#menubar-list-button').css('visibility','hidden');
          }
        },
        start:function(event, ui) {
            ui.helper.css('cursor','move');
            $('#menubar-list-button').css('visibility','visible');
          },
        update:function(event,ui){
            if($(".navigation-content .menubar").index(ui.item) == -1 || ui.sender != undefined){
              return;
            }else{
              ${is.changeRank(selector: ".navigation-content .menubar", controller: "user", action: "changeMenuOrder", params:[product:params?.product?:null])}
        }
      },
    receive:function(event,ui){
        ui.item.addClass('draggable-to-desktop');
        ui.item.removeAttr('hidden');
            ${is.changeRank(selector: ".navigation-content .menubar", controller: "user", action: "changeMenuOrder", params:[product:params?.product?:null])}
            if ($('#menubar-list-content > ul .menubar').size() > 0){
            $('#menubar-list-button').css('visibility','visible');
            }else{
              $('#menubar-list-button').css('visibility','hidden');
            }
          }
    }).disableSelection();

    $('#menubar-list-button').droppable({
      accept: '.menubar',
      drop:function(event,ui){
          var item = ui.draggable.clone();
          ui.draggable.remove();
          $('#menubar-list-content > ul').append(item);
          item.removeClass('draggable-to-desktop');
          item.show();
          item.attr('hidden','true');
          ${is.changeRank(selector: "#menubar-list-content > ul .menubar", controller: "user", action: "changeMenuOrder", ui:"item", params:[hidden:true,product:params?.product?:null])}
        },
      hoverClass:'menubar-list-button-hover'
    }).disableSelection();

    $('#menubar-list-content > ul').sortable({
      connectWith:'.navigation-content',
      items: '.menubar',
      revert:true,
      helper: 'clone',
      delay: 100,
       start:function(event, ui) {
            $(ui.helper).addClass('drag');
            ui.helper.css('cursor','move');
          },
      update:function(event,ui){
          if($("#menubar-list-content > ul .menubar").index(ui.item) == -1 || ui.sender != undefined){
            return;
          }else{
            ${is.changeRank(selector: "#menubar-list-content > ul .menubar", controller: "user", action: "changeMenuOrder", params:[hidden:true,product:params?.product?:null])}
          }
          event.stopPropagation();
        }
    }).disableSelection();
    $.icescrum.checkMenuBar();
    </jq:jquery>
</sec:ifLoggedIn>