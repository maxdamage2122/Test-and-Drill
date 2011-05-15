package components
{
	import spark.skins.mobile.TextInputSkin;

	public class TextBoxSkin extends TextInputSkin
	{
		public function TextBoxSkin()
		{
			super();
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//super.drawBackground(unscaledWidth, unscaledHeight);
			
			var borderSize:uint = (border) ? layoutBorderSize : 0;
			var borderWidth:uint = borderSize * 2;
			
			// Draw the contentBackgroundColor
			graphics.beginFill(0x464646); //getStyle("contentBackgroundColor"), getStyle("contentBackgroundAlpha"));
			graphics.drawRoundRect(borderSize, borderSize, unscaledWidth - borderWidth, unscaledHeight - borderWidth, layoutCornerEllipseSize, layoutCornerEllipseSize);
			graphics.endFill();
			
			graphics.beginFill(0x464646); //getStyle("contentBackgroundColor"), getStyle("contentBackgroundAlpha"));
			graphics.drawRoundRect(borderSize, borderSize, unscaledWidth - borderWidth, unscaledHeight - borderWidth, layoutCornerEllipseSize, layoutCornerEllipseSize);
			graphics.endFill();
			
			graphics.beginFill(0x464646); //getStyle("contentBackgroundColor"), getStyle("contentBackgroundAlpha"));
			graphics.drawRoundRect(borderSize, borderSize, unscaledWidth - borderWidth, unscaledHeight - borderWidth, layoutCornerEllipseSize, layoutCornerEllipseSize);
			graphics.endFill();
		}
	}
}