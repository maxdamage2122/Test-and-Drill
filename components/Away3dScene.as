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
		protected var cow:ObjectContainer3D;
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
			loadModel();
			startRendering();
		}
		
		protected function loadModel():void 
		{
			var loader3D:Loader3D = Collada.load("models/cow.dae");
			loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onModelLoadSuccess);
		}
		
		protected function onModelLoadSuccess(event:Loader3DEvent):void 
		{			
			cow = event.loader.handle as ObjectContainer3D;
			cow.scale(100);
			cow.moveDown(1);
			randomize();
			view.scene.addChild(cow);
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
			
			cow.z=distance;
			cow.rotationY=angle;
		}
	}
}