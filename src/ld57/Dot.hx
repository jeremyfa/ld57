package ld57;

import ceramic.Arc;
import ceramic.Color;
import ceramic.Timer;
import ceramic.Utils;
import ceramic.Visual;

class Dot extends Visual {

    public var arc(default, null):Arc;

    var extraScale:Float = 1;

    var lerpScale:Float = 1;

    var extraSkewX:Float = 0;

    var extraSkewY:Float = 0;

    public var scaleGap:Float = 0.01;

    public var lowProfile:Bool = false;

    public var pain(default,set):Bool = false;
    function set_pain(pain:Bool):Bool {
        this.pain = pain;
        if (pain) {
            extraSkewX = (Math.random() - 0.5) * 45;
            extraSkewY = (Math.random() - 0.5) * 45;
        }
        else {
            extraSkewX = 0;
            extraSkewY = 0;
        }
        return pain;
    }

    public var dizzy:Bool = false;

    public function new() {
        super();
        size(800, 800);

        arc = new Arc();
        arc.angle = 360;
        arc.anchor(0.5, 0.5);
        arc.pos(width * 0.5, height * 0.5);
        arc.color = Color.WHITE;
        arc.radius = 0;
        arc.thickness = width * 0.5;
        arc.sides = 48;
        add(arc);

        Timer.interval(this, 0.19, () -> {
            if (lowProfile && (arc.color == Color.WHITE || Math.random() > 0.5)) {
                extraScale = 0.85;
                if (!pain) {
                    arc.color = Color.interpolate(0xAAAAAA, 0xBBBBBB, Math.random());
                }
            }
            else if (!lowProfile) {
                extraScale = 1;
                if (!pain) {
                    arc.color = Color.WHITE;
                }
            }
            else if (!pain && !lowProfile && arc.color != Color.WHITE) {
                arc.color = Color.WHITE;
            }
            if (Math.random() > 0.5) {
                lerpScale = Utils.lerp(lerpScale, extraScale, 0.2);
            }
            if (Math.random() > 0.5) {
                arc.scaleX = (1.0 - scaleGap + (scaleGap * 2) * Math.random()) * lerpScale;
            }
            if (Math.random() > 0.5) {
                arc.scaleY = (1.0 - scaleGap + (scaleGap * 2) * Math.random()) * lerpScale;
            }
        });

        Timer.interval(this, 0.016, () -> {

            if (pain) {
                if (arc.skewX == 0 && arc.skewY == 0 || Math.random() > 0.5) {
                    arc.skew(
                        extraSkewX + 5 * (Math.random() - 0.5),
                        extraSkewY + 5 * (Math.random() - 0.5)
                    );
                }
                arc.color = Color.interpolate(Color.BLACK, Color.RED, 0.5 + 0.1 * Math.random());
                if (Math.random() > 0.95) {
                    extraSkewX = (Math.random() - 0.5) * 45;
                    extraSkewY = (Math.random() - 0.5) * 45;
                }
            }
            else if (!dizzy) {
                arc.skew(0, 0);
            }

        });

        var dizzyRatio:Float = 0;
        app.onUpdate(this, delta -> {
            if (!dizzy) return;

            dizzyRatio = (dizzyRatio + 0.1 * delta * Math.random()) % 1.0;
            final ratio = Utils.cosRatio(dizzyRatio);

            arc.skewX = (ratio - 0.5) * 50;
        });

    }

}