package particles;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;

class TitleEmitter extends FlxEmitter
{
	public function new(texture:String)
	{
		super(0, FlxG.height);

		launchMode = SQUARE;
		velocity.set(-25, -75, 25, -100, -50, 0, 50, -50);
		scale.set(0.25, 0.25, 0.5, 0.5, 0.25, 0.25, 0.37, 0.37);
		drag.set(0, 0, 0, 0, 5, 5, 10, 10);
		width = FlxG.width;
		alpha.set(0.7, 0.7, 0, 0);
		lifespan.set(1, 3);
		loadParticles(Paths.image('particles/$texture'), 500, 16, true);
	}
}
