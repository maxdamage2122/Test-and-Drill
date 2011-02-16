package components
{
	import away3d.containers.View3D;
	import away3d.core.math.Vector3DUtils;
	import away3d.lights.AmbientLight3D;
	import away3d.materials.BitmapFileMaterial;
	import away3d.primitives.Cube;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	//import mx.core.Application;
	import mx.core.UIComponent;
	
	import org.osmf.utils.URL;
	
	public class FlexView3D extends UIComponent
	{
		private var view:View3D;
		private var sceneLight:AmbientLight3D;
		
		//Test
		private var testCube:Cube;
		
		public function FlexView3D()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME, onFrameEnter);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!this.view)
			{
				this.view = new View3D();
				
				this.view.camera.moveTo(0, 0, -1500);
				//this.view.camera.lookAt(new Number3D(0, 0, 0));
				this.view.camera.lookAt(new Vector3D(0,0,0,0));
				
			}
			try
			{
				this.getChildIndex(this.view);
			}
			catch (e:Error)
			{
				this.addChild(this.view);
			}
			
			if(!this.testCube)
			{
				this.testCube = new Cube({name: "cube", size: 250, material: new BitmapFileMaterial("sotc.jpg")});
				
			}
			try
			{
				if(this.view.scene.getChildByName(this.testCube.name) == null)
					this.view.scene.addChild(this.testCube);
			}
			catch (e:Error)
			{
				this.view.scene.addChild(this.testCube);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(this.width / 2 != this.view.x)
				this.view.x = this.width / 2;
			if(this.height / 2 != this.view.y)
				this.view.y = this.height / 2;
		}
		
		private function onFrameEnter(event:Event):void
		{
			if(this.view && this.view.stage)
			{
				this.testCube.rotationX += .7;
				this.testCube.rotationY += .5;
				this.testCube.rotationZ += .4;
				
				this.view.render();
			}
		}
	}
}