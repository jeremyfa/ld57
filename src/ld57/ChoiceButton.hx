package ld57;

import ceramic.Assets;
import ceramic.Color;
import ceramic.RoundedRect;
import ceramic.Text;
import ceramic.Timer;
import ceramic.Visual;

using ceramic.VisualTransition;

class ChoiceButton extends Visual {

    var text:Text;

    var roundedRect:RoundedRect;

    var marginTop:Int = 6;

    var marginBottom:Int = 4;

    var marginX:Int = 20;

    public var index:Int;

    public function new(assets:Assets, index:Int, content:String, rotation:Float = 0) {
        super();

        anchor(0.5, 0.5);

        this.index = index;

        text = new Text();
        text.pointSize = 30;
        text.color = Color.BLACK;
        text.content = content;
        text.depth = 2;
        text.align = CENTER;
        text.lineHeight = 0.8;
        text.anchor(0.5, 0.5);
        text.font = assets.font(Fonts.POPPINS_BOLD);
        text.inheritAlpha = true;
        add(text);

        size(text.width + marginX * 2, text.height + marginTop + marginBottom);

        roundedRect = new RoundedRect();
        roundedRect.size(width, height);
        roundedRect.anchor(0.5, 0.5);
        roundedRect.color = Color.WHITE;
        roundedRect.radius(16);
        roundedRect.depth = 1;
        roundedRect.inheritAlpha = true;
        add(roundedRect);

        roundedRect.pos(width * 0.5, height * 0.5);
        text.pos(width * 0.5, height * 0.5 + marginTop - marginBottom);

        // roundedRect.rotation = rotation;
        // text.rotation = rotation;
        this.rotation = rotation;

        onPointerOver(this, _ -> {
            scale(1);
        });

        onPointerOut(this, _ -> {
            scale(0.8);
        });

    }

    public function stopScale() {
        offPointerOut();
        offPointerOver();
    }

    public function click(done:()->Void) {
        stopScale();
        scale(1);

        Timer.delay(this, 0.2, () -> {
            text.transition(LINEAR, 0.2, text -> {
                text.alpha = 0;
            })
            .onceComplete(this, () -> {
                var typeText = new TypeText(0.00, 0.25, 0.1);
                text.color = Color.WHITE;
                text.alpha = 1;
                text.component(typeText);
                var clearInterval:()->Void = null;
                clearInterval = Timer.interval(this, 0.1, () -> {
                    if (!typeText.typing) {
                        clearInterval();
                        Timer.delay(this, 1.0, done);
                    }
                });
            });

            roundedRect.transition(LINEAR, 0.2, roundedRect -> {
                roundedRect.alpha = 0;
            });
        });

    }

}