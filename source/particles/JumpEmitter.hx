package particles;

import flixel.effects.particles.FlxEmitter;

class JumpEmitter extends FlxEmitter
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		launchMode = CIRCLE;
		scale.set(0.1);
		alpha.set(0.7, 0.7, 0, 0);
		lifespan.set(0.5, 1);
		loadParticles(Paths.image('particles/jump'), 25);
	}
}
