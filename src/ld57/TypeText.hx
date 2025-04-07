package ld57;

import ceramic.Component;
import ceramic.Entity;
import ceramic.GlyphQuad;
import ceramic.Text;
import ceramic.Timer;
import ceramic.Tween;
import tracker.Observable;

class TypeText extends Entity implements Component implements Observable {

    public var charDelay:Float;

    public var stopDelay:Float;

    public var spaceDelay:Float;

    public var entity:Text;

    var tweens:Array<Tween> = [];

    var timers:Array<()->Void> = [];

    @observe public var typing(default, null):Bool = false;

    public function new(charDelay:Float = 0.033, stopDelay:Float = 0.5, spaceDelay:Float = 0.033) {

        super();

        this.charDelay = charDelay;
        this.stopDelay = stopDelay;
        this.spaceDelay = spaceDelay;

    }

    function bindAsComponent():Void {

        entity.onGlyphQuadsChange(this, reset);
        app.onUpdate(this, update);
        reset();

    }

    function update(delta:Float):Void {

        this.typing = (tweens.length > 0 || timers.length > 0);

    }

    public function skip():Void {

        while (timers.length > 0) {
            timers.pop()();
        }

        while (tweens.length > 0) {
            tweens.pop().destroy();
        }

        var len = entity.glyphQuads.length;
        for (i in 0...len) {
            var glyph = entity.glyphQuads[i];
            glyph.visible = true;
            glyph.alpha = 1;
        }

    }

    function reset() {

        typing = true;

        while (timers.length > 0) {
            timers.pop()();
        }

        while (tweens.length > 0) {
            tweens.pop().destroy();
        }

        var totalDelay:Float = 0.0;
        var len = entity.glyphQuads.length;
        for (i in 0...len) {
            var glyph = entity.glyphQuads[i];
            glyph.visible = false;
            glyph.alpha = 0;

            pushGlyphTimer(totalDelay, glyph);

            totalDelay += getGlyphDelay(glyph);
        }

    }

    function pushGlyphTimer(totalDelay:Float, glyph:GlyphQuad) {

        var timer:()->Void = null;
        timer = Timer.delay(this, totalDelay, () -> {

            timers.remove(timer);

            glyph.visible = true;
            var tw:Tween = null;
            tw = eagerTween(
                LINEAR, charDelay, 0, 1, (v, t) -> {
                    glyph.alpha = v;
                }
            );
            tw.onceComplete(this, () -> {
                tweens.remove(tw);
            });
            tweens.push(tw);

        });

        timers.push(timer);

    }

    function getGlyphDelay(glyph:GlyphQuad):Float {

        if (glyph == null || glyph.char == null)
            return 0;

        switch (glyph.char) {
            case '!' | '.' | ',' | '?' | ':', ';':
                return stopDelay;
            case ' ':
                return spaceDelay;
            default:
                return charDelay;
        }

    }

}
