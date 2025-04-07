package;

import ceramic.Color;
import ceramic.Entity;
import ceramic.InitSettings;

class Project extends Entity {

    function new(settings:InitSettings) {

        super();

        settings.antialiasing = 2;
        settings.background = Color.BLACK;
        settings.targetWidth = 1920;
        settings.targetHeight = 1080;
        settings.scaling = FIT;
        settings.resizable = true;
        settings.defaultFont = Fonts.POPPINS_REGULAR;
        settings.fullscreen = false;

        app.onceReady(this, ready);

    }

    function ready() {

        app.scenes.main = new ld57.Preloader(() -> new ld57.MainScene());

    }

}
