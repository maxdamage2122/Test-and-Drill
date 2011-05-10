package components
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.utils.ColorUtil;
	
	import spark.skins.mobile.ButtonSkin;

	public class NewButtonSkin extends ButtonSkin
	{
		public function NewButtonSkin()
		{
			super();
		}
		
		private static const CHROME_COLOR_RATIOS:Array = [0, 127.5];
		private static const CHROME_COLOR_ALPHAS:Array = [1, 1];
		private static var colorMatrix:Matrix = new Matrix();
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.drawBackground(unscaledWidth, unscaledHeight);
			
			var chromeColor:uint = 0x464646; //getStyle("chromeColor");
			
			// In the down state, the fill shadow is defined in the FXG asset
			if (currentState == "down")
			{
				graphics.beginFill(chromeColor);
			}
			else
			{
				var colors:Array = [];
				colorMatrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
				colors[0] = ColorUtil.adjustBrightness2(chromeColor, 20);
				colors[1] = ColorUtil.adjustBrightness2(chromeColor, -20);
				
				graphics.beginGradientFill(GradientType.LINEAR, colors, CHROME_COLOR_ALPHAS, CHROME_COLOR_RATIOS, colorMatrix);
			}
			
			// inset chrome color by BORDER_SIZE
			// bottom line is a shadow
			graphics.drawRoundRect(layoutBorderSize, layoutBorderSize, 
				unscaledWidth - (layoutBorderSize * 2), 
				unscaledHeight - (layoutBorderSize * 2), 
				layoutCornerEllipseSize, layoutCornerEllipseSize);
			graphics.endFill();
		}
	}
}