package ld57;

import ceramic.Color;
import ceramic.Scene;
import ceramic.SeedRandom;
import ceramic.Text;
import ceramic.Timer;
import ceramic.TouchInfo;
import ceramic.Triangle;
import ceramic.Tween;
import ceramic.Utils;
import loreline.Interpreter;
import loreline.Loreline;
import tracker.Until;

using ceramic.Extensions;
using ceramic.VisualTransition;

class MainScene extends Scene {

    var dot:Dot;

    var triangle:Triangle;

    var text:Text;

    var typeText:TypeText;

    var italicText:ItalicText;

    var circleMood:String = null;

    var doctorColor:Color = 0x61AFEF;

    var lastCharacter:String = null;

    var belowSurfaceText:Text = null;

    var belowSurfaceMeters:Float = 0;

    var belowSurfaceMetersTween:Tween = null;

    var belowSurfaceMetersDelay:()->Void = null;

    var lang:String = null;

    var titleText:Text = null;

    var gameCredit:Text = null;

    var contentWarning:Text = null;

    override function preload() {

        assets.add(Fonts.POPPINS_BOLD);
        assets.add(Lorelines.STORY_FR);
        assets.add(Lorelines.STORY_EN);

    }

    override function create() {

        titleText = new Text();
        titleText.font = assets.font(Fonts.POPPINS_BOLD);
        titleText.content = "When it Sinks";
        titleText.pointSize = 100;
        titleText.anchor(0.5, 0.5);
        titleText.pos(width * 0.5, height * 0.4);
        titleText.color = Color.WHITE;
        titleText.alpha = 0;
        add(titleText);

        gameCredit = new Text();
        gameCredit.color = Color.WHITE;
        gameCredit.alpha = 0;
        gameCredit.content = "This game prototype was created by Jérémy Faivre in less than two days for Ludum Dare 57, with the theme 'Depths'.";
        gameCredit.align = CENTER;
        gameCredit.pointSize = 18;
        gameCredit.anchor(0.5, 0.5);
        gameCredit.pos(width * 0.5, height * 0.9);
        add(gameCredit);

        contentWarning = new Text();
        contentWarning.color = Color.WHITE;
        contentWarning.alpha = 0;
        contentWarning.content = "Warning: this game is talking about cognitive impairment and mental health issues that some players may find distressing.";
        contentWarning.align = CENTER;
        contentWarning.pointSize = 18;
        contentWarning.font = assets.font(Fonts.POPPINS_BOLD);
        contentWarning.anchor(0.5, 0.5);
        contentWarning.pos(width * 0.5, height * 0.9 + 32);
        add(contentWarning);

        Timer.delay(this, 0.6, () -> {
            titleText.transition(LINEAR, 1.0, titleText -> {
                titleText.alpha = 1;
            });

            gameCredit.transition(LINEAR, 1.0, gameCredit -> {
                gameCredit.alpha = 0.7;
            });

            contentWarning.transition(LINEAR, 1.0, contentWarning -> {
                contentWarning.alpha = 0.7;
            });
        });

        function clear() {
            titleText.transition(LINEAR, 0.25, titleText -> {
                titleText.alpha = 0;
            }).onceComplete(this, () -> {
                titleText.destroy();
                titleText = null;
            });
            gameCredit.transition(LINEAR, 0.25, gameCredit -> {
                gameCredit.alpha = 0;
            }).onceComplete(this, () -> {
                gameCredit.destroy();
                gameCredit = null;
            });
            contentWarning.transition(LINEAR, 0.25, contentWarning -> {
                contentWarning.alpha = 0;
            }).onceComplete(this, () -> {
                contentWarning.destroy();
                contentWarning = null;
            });
        }

        Timer.delay(this, 1.3, () -> {
            var frButton = new ChoiceButton(assets, 0, "Jouer en français");
            var enButton = new ChoiceButton(assets, 1, "Play in english");

            frButton.pos(width * 0.4, height * 0.6);
            frButton.scale(0.0001);
            frButton.transition(LINEAR, 0.15, frButton -> {
                frButton.scale(0.8);
            });
            frButton.oncePointerDown(this, _ -> {
                enButton.destroy();
                frButton.click(() -> {
                    lang = "fr";
                    clear();
                    frButton.transition(QUAD_EASE_IN_OUT, 0.25, frButton -> {
                        frButton.alpha = 0;
                    }).onceComplete(this, () -> {
                        frButton.destroy();
                        start();
                    });
                });
            });
            add(frButton);

            enButton.pos(width * 0.6, height * 0.6);
            enButton.scale(0.0001);
            enButton.transition(LINEAR, 0.15, enButton -> {
                enButton.scale(0.8);
            });
            enButton.oncePointerDown(this, _ -> {
                frButton.destroy();
                enButton.click(() -> {
                    lang = "en";
                    clear();
                    enButton.transition(QUAD_EASE_IN_OUT, 0.25, enButton -> {
                        enButton.alpha = 0;
                    }).onceComplete(this, () -> {
                        enButton.destroy();
                        start();
                    });
                });
            });
            add(enButton);
        });

    }

    function start() {

        // Called when scene has finished preloading

        /*
        belowSurfaceText = new Text();
        belowSurfaceText.align = CENTER;
        belowSurfaceText.pointSize = 20;
        belowSurfaceText.color = Color.WHITE;
        belowSurfaceText.content = "";
        belowSurfaceText.anchor(0.5, 0.5);
        belowSurfaceText.pos(width * 0.5, 40);
        belowSurfaceText.alpha = 0;
        belowSurfaceText.font = assets.font(Fonts.POPPINS_BOLD);
        add(belowSurfaceText);
        */

        // Display dot
        dot = new Dot();
        dot.anchor(0.5, 0.5);
        dot.pos(width * 0.5, height * 0.4);
        dot.scale(0.0001);
        dot.alpha = 0;
        add(dot);

        // Prepare triangle
        triangle = new Triangle();
        triangle.size(400, 500);
        triangle.color = doctorColor;
        triangle.anchor(0.5, 0.5);
        triangle.pos(width * 0.5, height * 0.4);
        triangle.scale(0.0001);
        triangle.alpha = 0;
        add(triangle);

        // Setup text
        text = new Text();
        text.align = CENTER;
        text.anchor(0.5, 0.5);
        text.pointSize = 40;
        text.fitWidth = width * 0.6;
        text.content = "";
        text.pos(width * 0.5, height * 0.75);
        text.color = Color.WHITE;
        add(text);

        // Scale "in" animation
        dot.tween(SINE_EASE_IN_OUT, 3.75, 0.0001, 1.0, function(value, time) {
            dot.alpha = value;
            dot.scale(value);
        })
        .onceComplete(this, startStory);

    }

    function startStory() {

        Loreline.play(
            assets.loreline(lang == "fr" ? Lorelines.STORY_FR : Lorelines.STORY_EN),
            handleDialogue,
            handleChoice,
            handleFinish,
            null,
            {
              functions: [
                "mood" => handleMood,
                "meters" => handleMeters
              ]
            }
        );

    }

    function handleMood(mood:String) {

        trace("MOOD: " + mood);

        dot.pain = (mood == "pain");
        dot.dizzy = (mood == "dizzy");

    }

    function handleMeters(meters:Int) {

        trace("METERS: " + meters);

        /*
        if (belowSurfaceMetersDelay != null) {
            belowSurfaceMetersDelay();
            belowSurfaceMetersDelay = null;
        }

        if (belowSurfaceMetersTween != null) {
            belowSurfaceMetersTween.destroy();
            belowSurfaceMetersTween = null;
        }

        belowSurfaceText.eagerTransition(LINEAR, 0.5, belowSurfaceText -> {
            belowSurfaceText.alpha = 0.5;
        })
        .onceComplete(this, () -> {
            final startMeters = belowSurfaceMeters;
            belowSurfaceMetersTween = Tween.start(this, SINE_EASE_IN_OUT, 1.0, 0, 1, (v, t) -> {
                belowSurfaceMeters = Math.round(startMeters + (meters - startMeters) * v);

                if (lang == "fr") {
                    belowSurfaceText.content = Math.abs(belowSurfaceMeters) + " mètres sous la surface";
                }
                else {
                    belowSurfaceText.content = Math.abs(belowSurfaceMeters) + " meters below surface";
                }

            });
            belowSurfaceMetersTween.onceComplete(this, () -> {
                belowSurfaceMetersDelay = Timer.delay(this, 1.0, () -> {
                    belowSurfaceMetersDelay = null;
                    belowSurfaceText.transition(LINEAR, 0.3, belowSurfaceText -> {
                        belowSurfaceText.alpha = 0;
                    });
                });
            });
        });
        */

    }

    function showDot() {

        dot.transition(ELASTIC_EASE_IN_OUT, 0.4, dot -> {
            dot.translateY = 0;
            dot.scale(1);
        });

    }

    function hideDot() {

        dot.transition(ELASTIC_EASE_IN_OUT, 0.4, dot -> {
            dot.translateY = 500;
            dot.scale(0.15);
        });

    }

    function showTriangle() {

        triangle.alpha = 1;
        triangle.transition(ELASTIC_EASE_IN_OUT, 0.4, triangle -> {
            triangle.scale(1);
        });

    }

    function hideTriangle() {

        triangle.transition(ELASTIC_EASE_IN_OUT, 0.4, triangle -> {
            triangle.scale(0.001);
        }).onceComplete(this, () -> {
            triangle.alpha = 0;
        });

    }

    function handleDialogue(interpreter:Interpreter, character:String, content:String, tags:Array<TextTag>, callback:()->Void) {

        var delay:Float = 0;

        if (lastCharacter != character) {
            delay = 0.5;
            lastCharacter = character;
        }

        if (character == 'player') {

            dot.lowProfile = false;

            showDot();
            hideTriangle();

            Timer.delay(this, delay, () -> {
                typeText = new TypeText(0.00, 0.25, 0.1);
                text.alpha = 1;
                text.color = dot.pain ? Color.interpolate(Color.BLACK, Color.RED, 0.75) : Color.WHITE;
                text.component(typeText);
                text.content = content;

                function updateFromDot(delta:Float) {
                    if (dot.pain) {
                        text.color = dot.arc.color;
                        text.skew(
                            dot.arc.skewX * 0.5,
                            dot.arc.skewY * 0.1
                        );
                    }
                    else if (dot.dizzy) {
                        text.skew(
                            dot.arc.skewX,
                            -dot.arc.skewX * 0.15
                        );
                    }
                }
                app.onUpdate(this, updateFromDot);

                var handleDown:(info:TouchInfo)->Void = null;
                handleDown = (_) -> {
                    if (typeText != null && typeText.typing) {
                        typeText.skip();
                    }
                    else {
                        app.offUpdate(updateFromDot);
                        offPointerDown(handleDown);
                        hideText(callback, character);
                    }
                }
                onPointerDown(this, handleDown);
            });
        }
        else if (character == 'doctor') {

            dot.lowProfile = false;

            hideDot();
            showTriangle();

            Timer.delay(this, delay, () -> {
                typeText = new TypeText(0.033, 0.5, 0);
                text.alpha = 1;
                text.component(typeText);
                text.content = content;
                text.color = doctorColor;

                var handleDown:(info:TouchInfo)->Void = null;
                handleDown = (_) -> {
                    if (typeText != null && typeText.typing) {
                        typeText.skip();
                    }
                    else {
                        offPointerDown(handleDown);
                        hideText(callback, character);
                    }
                }
                onPointerDown(this, handleDown);
            });

        }
        else {

            showDot();
            hideTriangle();

            dot.lowProfile = true;

            Timer.delay(this, delay, () -> {
                italicText = new ItalicText();
                text.component(italicText);
                text.content = content;
                text.alpha = 0;
                text.transition(LINEAR, 0.4, text -> {
                    text.alpha = 0.8;
                })
                .onceComplete(this, () -> {
                    oncePointerDown(this, _ -> {
                        hideText(callback, character);
                    });
                });
            });
        }

    }

    function resetText() {

        if (typeText != null) {
            typeText.destroy();
            typeText = null;
        }

        if (italicText != null) {
            italicText.destroy();
            italicText = null;
        }

        for (glyph in text.glyphQuads) {
            glyph.skew(0, 0);
        }
        text.skew(0, 0);
        text.color = Color.WHITE;
        text.content = "";
        text.alpha = 1;
        text.scale(1);

    }

    function hideText(callback:()->Void, character:String) {

        function hideComplete(delay:Float) {

            Timer.delay(this, delay, () -> {

                resetText();
                callback();

            });

        }

        if (character == "player") {
            text.alpha = 0.75;
            text.scale(
                Utils.lerp(1.0, (text.width + 50) / text.width, 0.25),
                Utils.lerp(1.0, 0.1 * 0.5, 0.25)
            );
            Timer.delay(this, 0.05, () -> {
                text.alpha = 0.5;
                text.scale(
                    Utils.lerp(1.0, (text.width + 50) / text.width, 0.75),
                    Utils.lerp(1.0, 0.1 * 0.5, 0.75)
                );
            });
            Timer.delay(this, 0.1, () -> {
                text.alpha = 0;
                text.scale(
                    Utils.lerp(1.0, (text.width + 50) / text.width, 1),
                    Utils.lerp(1.0, 0.1 * 0.5, 1)
                );
            });
            hideComplete(0.4);
        }
        else {
            text.transition(QUAD_EASE_OUT, 0.2, text -> {
                text.alpha = 0;
                //text.scale((text.width + 50) / text.width, 0.1);
            })
            .onceComplete(this, () -> hideComplete(0.2));
        }

    }

    function seedFromString(str:String):Int {

        // Create a numeric seed from a string
        if (str == null || str.length == 0) return 0;

        var hash:Int = 0;
        for (i in 0...str.length) {
            // Multiply by 31 (common hash multiplier) and add character code
            hash = ((hash << 5) - hash) + str.charCodeAt(i);
            // Force to 32 bit integer to avoid overflow issues
            hash |= 0;
        }
        return Std.int(Math.abs(hash));

    }

    function handleChoice(interpreter:Interpreter, options:Array<ChoiceOption>, callback:(index:Int)->Void) {

        var clearDotMood:()->Void = null;
        var clearButtonsInterval:()->Void = null;

        var clicked = false;

        hideTriangle();

        dot.transition(ELASTIC_EASE_IN_OUT, 0.4, dot -> {
            dot.translateY = 0;
            dot.scale(0.2);
        })
        .onComplete(this, () -> {
            clearDotMood = Timer.interval(this, 0.05, () -> {
                dot.scale((clicked ? 0.25 : 1.0) * (0.185 + 0.03 * Math.random()));
                dot.alpha = 0.85 + 0.15 * Math.random();
            });

            var buf = new StringBuf();
            var numChoices = 0;
            for (opt in options) {
                if (opt.enabled) {
                    numChoices++;
                    buf.addChar(" ".code);
                    buf.addChar("~".code);
                    buf.add(Std.string(numChoices));
                    buf.addChar(" ".code);
                    buf.add(opt.text);
                }
            }
            final seed = seedFromString(buf.toString());
            final rnd = new SeedRandom(seed);

            var i = 0;
            final choiceButtons:Array<ChoiceButton> = [];

            function bindButton(choiceButton:ChoiceButton) {

                choiceButton.oncePointerDown(this, _ -> {

                    touchable = false;
                    clicked = true;

                    clearButtonsInterval();

                    for (button in choiceButtons) {
                        if (button != choiceButton) {
                            button.stopScale();
                        }
                    }

                    Timer.delay(this, 0.1, () -> {
                        for (button in choiceButtons) {
                            if (button != choiceButton) {
                                button.touchable = false;
                                button.alpha = 0.5;
                                button.skewX = (Math.random() - 0.5) * 25;
                            }
                        }
                    });

                    Timer.delay(this, 0.2, () -> {
                        for (button in choiceButtons) {
                            if (button != choiceButton) {
                                button.alpha = 0.25;
                            }
                        }
                    });

                    Timer.delay(this, 0.3, () -> {
                        for (button in choiceButtons) {
                            if (button != choiceButton) {
                                button.destroy();
                            }
                        }
                    });

                    choiceButton.click(() -> {
                        choiceButton.destroy();
                        clearDotMood();
                        touchable = true;

                        dot.transition(ELASTIC_EASE_IN_OUT, 0.4, dot -> {
                            if (lastCharacter == "player") {
                                dot.scale(1);
                            }
                        })
                        .onceComplete(this, () -> {
                            callback(choiceButton.index);
                        });
                    });

                });

            }

            final minXGap = width * 0.1;
            final minYGap = height * 0.1;
            var index:Int = 0;
            for (opt in options) {
                if (opt.enabled) {

                    var choiceButton = new ChoiceButton(assets, index, opt.text, (rnd.random() - 0.5) * 30);
                    choiceButton.depth = 10 + i;
                    choiceButton.scale(0.8, 0.00001);

                    choiceButton.transition(LINEAR, 0.15, choiceButton -> {
                        choiceButton.scale(0.8);
                    });

                    bindButton(choiceButton);

                    var n = 0;
                    while (n++ < 10000) {
                        choiceButton.pos(
                            width * 0.25 + width * 0.5 * rnd.random(),
                            height * 0.25 + height * 0.5 * rnd.random()
                        );

                        var tooClose = false;
                        for (otherButton in choiceButtons) {
                            if (Math.abs(choiceButton.x - otherButton.x) < minXGap && Math.abs(choiceButton.x - otherButton.x) < minYGap) {
                                tooClose = true;
                                break;
                            }
                        }

                        if (Math.abs(choiceButton.y - dot.y) < minYGap) {
                            tooClose = true;
                        }

                        if (!tooClose) {
                            break;
                        }
                    }

                    add(choiceButton);
                    choiceButtons.push(choiceButton);

                    i++;
                }

                Timer.delay(this, 0.31, () -> {
                    clearButtonsInterval = Timer.interval(this, 0.1, () -> {
                        var newRotation = (rnd.random() - 0.5) * 30;
                        var button = choiceButtons.randomElement();
                        var prevRotation = button.rotation;
                        button.rotation = Utils.lerp(prevRotation, newRotation, 0.02);
                    });
                });

                index++;
            }
        });

    }

    function handleFinish(interpreter:Interpreter) {
        trace("HANDLE FINISH");

    }

    override function update(delta:Float) {

    }

    override function resize(width:Float, height:Float) {

        // Called everytime the scene size has changed

    }

    override function destroy() {

        // Perform any cleanup before final destroy

        super.destroy();

    }

}
