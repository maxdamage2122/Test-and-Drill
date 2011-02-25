package components  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Collada;
	import away3d.loaders.Loader3D;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class Away3dScene extends UIComponent
	{
		protected var models:Array = [
			["cow.dae", 100, 1, 90],
			["sailboat.dae", 60, 2.5, 180],
			["speedboat.dae", 8, 8, 90]
		];
		protected var curModel:uint;
		protected var ship:ObjectContainer3D;
		protected var view:View3D;
		public var distance:int;
		public var angle:int;
		
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
		}
		
		public function loadModel():void
		{
			curModel = Math.floor(Math.random()*3);
			var loader3D:Loader3D = Collada.load("models/"+models[curModel][0]);
			loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onModelLoadSuccess);
		}
		
		protected function onModelLoadSuccess(event:Loader3DEvent):void 
		{			
			if (ship != null)
				view.scene.removeChild(ship);
			ship = event.loader.handle as ObjectContainer3D;
			ship.scale(models[curModel][1]);
			ship.moveDown(models[curModel][2]);
			randomize();
			view.scene.addChild(ship);
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
		
		public function randomize():void
		{
			distance=Math.floor(Math.random() * 4100) + 1;
			angle=Math.floor(Math.random() * 360) + 1;
			
			ship.z=distance;
			ship.rotationY=angle+models[curModel][3];
		}
	}
}