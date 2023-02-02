package meta.states.shaders;

import flixel.FlxBasic;
import flixel.system.FlxAssets.FlxShader;

class RetroShader extends FlxBasic
{
	public var shader(default, null):BWGShader = new BWGShader();

	var iTime:Float = 0;

	public function new():Void
	{
		super();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		iTime += elapsed;
		shader.iTime.value = [iTime];
	}
}

class BWGShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float iTime;

        void main() {
            vec2 uv = openfl_TextureCoordv;
            
            vec4 color = flixel_texture2D(bitmap, uv);
            float average = 0.2126 * color.x + 0.7152 * color.y + 0.0722 * color.z;
            color = vec4(vec3(average), 1);
    
            float strength = 16.0;
    
            float x = (uv.x + 4.0 ) * (uv.y + 4.0 ) * (iTime * 10.0);
	        vec4 grain = vec4(mod((mod(x, 13.0) + 1.0) * (mod(x, 123.0) + 1.0), 0.01)-0.005) * strength;
            grain = 1.0 - grain;
            
            gl_FragColor = color * grain;
        }
    ')
	public function new()
	{
		super();
	}
}
