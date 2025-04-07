package ld57;

#if web

import js.Browser;
import js.html.Element;

class Fullscreen {
    public static function openFullscreen(element:Element):Void {
        if (element.requestFullscreen != null) {
            element.requestFullscreen();
        } else if (untyped element.webkitRequestFullscreen != null) {
            untyped element.webkitRequestFullscreen();
        } else if (untyped element.msRequestFullscreen != null) {
            untyped element.msRequestFullscreen();
        } else if (untyped element.mozRequestFullScreen != null) {
            untyped element.mozRequestFullScreen();
        }
    }

    public static function closeFullscreen():Void {
        var doc = Browser.document;
        if (doc.exitFullscreen != null) {
            doc.exitFullscreen();
        } else if (untyped doc.webkitExitFullscreen != null) {
            untyped doc.webkitExitFullscreen();
        } else if (untyped doc.msExitFullscreen != null) {
            untyped doc.msExitFullscreen();
        } else if (untyped doc.mozCancelFullScreen != null) {
            untyped doc.mozCancelFullScreen();
        }
    }

    public static function isFullscreen():Bool {
        var doc = Browser.document;
        return doc.fullscreenElement != null ||
               untyped doc.webkitFullscreenElement != null ||
               untyped doc.msFullscreenElement != null ||
               untyped doc.mozFullScreenElement != null;
    }

}

#end
