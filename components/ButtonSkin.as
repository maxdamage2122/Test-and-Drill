////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package components
{
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.states.SetProperty;
	import mx.states.State;
	import mx.utils.ColorUtil;
	
	import spark.skins.mobile.assets.Button_down;
	import spark.skins.mobile.assets.Button_up;
	import spark.skins.mobile.supportClasses.ButtonSkinBase;
	
	/*    
	ISSUES:
	- should we support textAlign
	
	*/
	/**
	 *  Actionscript based skin for mobile applications. The skin supports 
	 *  iconClass and labelPlacement. It uses a couple of FXG classes to 
	 *  implement the vector drawing.  
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5 
	 *  @productversion Flex 4.5
	 */
	public class ButtonSkin extends ButtonSkinBase
	{	
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function ButtonSkin()
		{
			super();
			upBorderSkin = Button_up;
			downBorderSkin = Button_down;
			this.paddingBottom = 0;
			this.paddingLeft = 0;
			this.paddingRight = 0;
			this.paddingTop = 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var bgImg:DisplayObject;
		
		private var changeFXGSkin:Boolean = false;
		private var borderClass:Class;
		
		private static var matrix:Matrix = new Matrix();
		
		// Used for gradient background
		private static const alphas:Array = [1, 1, 1];
		private static const ratios:Array = [0, 127.5, 255];
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Class to use for the border in the up state.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 * 
		 *  @default Button_up
		 */  
		protected var upBorderSkin:Class;
		
		/**
		 *  Class to use for the border in the up state.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 *       
		 *  @default Button_down
		 */ 
		protected var downBorderSkin:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private 
		 */
		override protected function commitCurrentState():void
		{   
			super.commitCurrentState();
			
			if (currentState == "down") 
				borderClass = downBorderSkin;
			else
				borderClass = upBorderSkin;
			
			if (!(bgImg is borderClass))
			{
				changeFXGSkin = true;
				invalidateDisplayList();
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// Size the FXG background   
			if (changeFXGSkin)
			{
				changeFXGSkin = false;
				
				if (bgImg)
				{
					removeChild(bgImg);
					bgImg = null;
				}
				
				if (borderClass)
				{
					bgImg = new borderClass();
					addChildAt(bgImg, 0);
				}
			}
			
			if (bgImg != null) 
			{
				layoutBorder(bgImg, unscaledWidth, unscaledHeight);
			}
			
			drawBackground(unscaledWidth, unscaledHeight);
			
			// The label and icon should be placed on top of the FXG skins
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		/**
		 *  Position the background of the skin. Override this function to position of the background. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 */ 
		protected function layoutBorder(bgImg:DisplayObject, unscaledWidth:Number, unscaledHeight:Number):void
		{
			bgImg.x = bgImg.y = 0.5;
			bgImg.width = unscaledWidth;
			bgImg.height = unscaledHeight;
		}
		
		/**
		 *  Draws the background of the skin. Override this function to change the background. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5 
		 *  @productversion Flex 4.5
		 *       
		 *  @default Button_down
		 */ 
		protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var colors:Array = [];
			
			graphics.clear();
			
			// Draw the gradient background
			matrix.createGradientBox(unscaledWidth - 1, unscaledHeight - 1, Math.PI / 2, 0, 0);
			var chromeColor:uint = getStyle("chromeColor");
			colors[0] = ColorUtil.adjustBrightness2(chromeColor, 20);
			colors[1] = chromeColor;
			colors[2] = ColorUtil.adjustBrightness2(chromeColor, -20);
			
			graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			
			// Draw the background rectangle within the border, so the corners of the rect don't 
			// spill over into the rounded corners of the Button
			graphics.drawRect(1, 1, unscaledWidth - 1, unscaledHeight - 1);
			graphics.endFill();
		}
		
	}
}