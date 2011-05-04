package components  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.clip.Clipping;
	import away3d.core.filter.FogFilter;
	import away3d.core.render.BasicRenderer;
	import away3d.core.vos.FogVO;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Collada;
	import away3d.loaders.Loader3D;
	import away3d.materials.BitmapFileMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TransformBitmapMaterial;
	import away3d.primitives.Plane;
	import away3d.sprites.Sprite3D;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	
	import spark.primitives.BitmapImage;
	
	public class Away3dScene extends UIComponent
	{
		protected var models:Array = [
			
			["sailboat.dae", 12, 0.75, 180],
			["speedboat.dae", 0.4, 5, 90],
			["cargo.dae", 4.5, 3, -90]
			
		];
		//["cow.dae", 100, 1, 90],
		protected var curModel:uint;
		protected var ship:ObjectContainer3D;
		protected var view:View3D;
		public var distance:int;
		public var angle:int;
		public var level:int;
		protected var zoomed:Boolean=false;
		protected var zoomValue:Number;
		protected var day:BitmapFileMaterial;
		protected var night:BitmapFileMaterial;
		protected var background:Sprite;
		[Embed (source="images/daySky.png")]
		public static const Background1:Class;
		public static const Background1_BitmapAsset:BitmapAsset = new Background1();
		public static const Background1_Tex:TransformBitmapMaterial = new TransformBitmapMaterial(Background1_BitmapAsset.bitmapData);
		[Embed (source="images/nightSky.png")]
		public static const Background2:Class;
		public static const Background2_BitmapAsset:BitmapAsset = new Background2();
		public static const Background2_Tex:TransformBitmapMaterial = new TransformBitmapMaterial(Background2_BitmapAsset.bitmapData);
		[Embed (source="images/water.png")]
		public static const Water1:Class;
		public static const Water1_BitmapAsset:BitmapAsset = new Water1();
		public static const Water1_Tex:TransformBitmapMaterial = new TransformBitmapMaterial(Water1_BitmapAsset.bitmapData);
		[Embed (source="images/nightWater.png")]
		public static const Water2:Class;
		public static const Water2_BitmapAsset:BitmapAsset = new Water2();
		public static const Water2_Tex:TransformBitmapMaterial = new TransformBitmapMaterial(Water2_BitmapAsset.bitmapData);
		protected static const ZPOS:Number = 5101;
		protected static const WIDTH:Number = 3500;
		protected static const HEIGHT:Number = 3000;
		protected var bgmaterial:TransformBitmapMaterial = null;
		protected var watermaterial:TransformBitmapMaterial = null;
		
			
			
			public var bground:Object3D = null;
			public var water:Object3D = null;
			
			public function startupBackgroundPlane(lvl:Number):void
			{
				if(lvl%2==0)
				{
					bgmaterial = Background2_Tex;
					watermaterial = Water2_Tex;
				}else{
					bgmaterial = Background1_Tex;
					watermaterial = Water1_Tex;
				}
				if(bground!=null)
					view.scene.removeChild(bground);
				
				bground = new Plane({	material:bgmaterial,
					width:WIDTH,
					height:HEIGHT});
				view.scene.addChild(bground);
				
				
				bground.rotationX = 90;
				bground.y = 0;
				bground.z = ZPOS;
				
				if(water!=null)
					view.scene.removeChild(water);
				water= new Plane ({material:watermaterial, width:1500, height:500});
				view.scene.addChild(water);
				water.rotationX = 90;
				water.y=-260+((distance-1000)/200);
				water.z=750;
				
			} 
		public function Away3dScene() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);	
		}
		
		override protected function createChildren():void 
		{
			view = new View3D();//{x:stage.stageWidth/2, y:stage.stageHeight/2});
			addChild(view);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(this.width / 2 != this.view.x)
				this.view.x = this.width / 2;
			if(this.height / 2 != this.view.y)
				this.view.y = this.height / 2;
		}
		
		protected function onAddedToStage(event:Event):void 
		{
			startRendering();
			//
		}
		
		public function loadModel(lvl:Number):void
		{   
			level=lvl;
			curModel = Math.floor(Math.random()*3);
			var loader3D:Loader3D = Collada.load("models/"+models[curModel][0]);
			loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onModelLoadSuccess);
			
			//view.camera.y=10;
		}
		
		protected function onModelLoadSuccess(event:Loader3DEvent):void 
		{			
			if (ship != null)
				view.scene.removeChild(ship);
			ship = event.loader.handle as ObjectContainer3D;
			ship.scale(models[curModel][1]);
			ship.moveDown(models[curModel][2]);
			randomize(level);
			view.scene.addChild(ship);
			zoomValue=view.camera.zoom;
			
			
		}
		
		protected function startRendering():void 
		{
			addEventListener(Event.ENTER_FRAME, onRenderTick);
			
		}
		
		protected function onRenderTick(event:Event = null):void 
		{			
			//Render View
			view.render();
			
		}
		
		public function randomize(lvl:Number):void
		{
			if (curModel==1){
				distance=Math.floor(Math.random() * 1750) + 250;
			}else
			distance=Math.floor(Math.random() * 4100) + 500;
			angle=Math.floor(Math.random() * 360) + 1;
			
			ship.z=distance;
			ship.rotationY=angle+models[curModel][3];
			startupBackgroundPlane(lvl);
		}
		
		public function zoom():void
		{
			if(!zoomed){
				view.camera.zoom=28;
				zoomed=true;
			} else
			{   //set back to original zoom
				view.camera.zoom=zoomValue;
				zoomed=false;
			}
		}
		
		public function resetZoom():void
		{
			view.camera.zoom=zoomValue;
			zoomed=false;
		}
	}
}