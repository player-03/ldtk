package ui;

class Window extends dn.Process {
	public var client(get,never) : Client; inline function get_client() return Client.ME;
	public var project(get,never) : ProjectData; inline function get_project() return Client.ME.project;
	public var curLevel(get,never) : LevelData; inline function get_curLevel() return Client.ME.curLevel;

	var jWin: js.jquery.JQuery;
	var jContent : js.jquery.JQuery;
	var jMask: js.jquery.JQuery;

	public function new() {
		super(Client.ME);

		jWin = new J("xml#window").children().first().clone();
		new J("body").append(jWin);

		jContent = jWin.find(".content");

		jMask = jWin.find(".mask");
		jMask.click( function(_) close() );
		jMask.hide().fadeIn(100);

		client.ge.watchAny(onGlobalEvent);
	}

	override function onDispose() {
		super.onDispose();

		client.ge.remove(onGlobalEvent);
		jWin = null;
		jMask = null;
		jContent = null;
	}

	function onGlobalEvent(e:GlobalEvent) {
	}

	public function close() {
		jWin.find("*").off();
		jMask.fadeOut(50);
		jContent.stop(true,false).animate({ width:"toggle" }, 100, function(_) {
			jWin.remove();
			destroy();
		});
	}

	public function loadTemplate(tpl:hxd.res.Resource, className:String) {
		jWin.addClass(className);
		var content = new J( tpl.entry.getText() );
		jContent.empty().append(content);
	}
}
