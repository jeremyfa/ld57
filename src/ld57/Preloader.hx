package ld57;

class Preloader extends ceramic.Preloader {

    override function createGraphics():Void {

        initPreloadable();
        createProgressBar();

    }

}