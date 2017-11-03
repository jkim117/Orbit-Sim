//
//  GameViewController.swift
//  Orbits
//
//  Created by jason kim on 1/31/17.
//  Copyright © 2017 jason kim. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var aValues = [0.3870982252717257,0.7233268496749391,1.000371833989169,1.523678184302188,2.307355347325137]
    var eValues = [0.2056302512089075,0.006755697267164094,0.01704239716781501,0.09331460653723893,0.5503472901025839]
    var oValues = [48.33053756455964,76.67837563371675,163.9752443600624,49.56199966373916,215.1657829181022]
    var iValues = [7.005014199657344,3.394589632336535,0.0002669113820737183,1.849876609221010,3.233604543786646]
    var wValues = [29.12428058698772,55.18541455452200,297.7668064579176,286.5373577554387,95.74741833716503]
    var mValues = [172.7497133778637,49.31425178852966,358.1891404220149,19.09450886999620,98.72778265595174]
    var currentPlanet = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/bodies.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        // animate the 3d object
        //*************************************************************************
        //Updates M based on time
        func MVcalc(a: Double, k: Double, mu: Double, T: Double) -> Double
        {
            let n=k*sqrt(mu/pow(a,3))
            return n*T
        }
        
        //The function f that is used within Newton's Method
        func functionf(M: Double, E: Double, e: Double) -> Double
        {
            return M-(E-e*sin(E))
        }
        
        //Newton's Method for approximating E
        func newton(M: Double, e: Double) -> Double
        {
            var Eguess = M
            var Mguess = Eguess - e*sin(Eguess)
            while abs(Mguess - M) > 1e-004
            {
                Eguess = Eguess - functionf(M: M,E: Eguess,e: e)/(e*cos(Eguess)-1)
                Mguess = Eguess - e*sin(Eguess)
            }
            return Eguess
        }
        
        //Position Vector
        func position(a: Double, E: Double, e: Double) -> Array<Double>
        {
            let x=a*cos(E)-a*e
            let y=a*sqrt(1-e*e)*sin(E)
            let z=0.0
            let pos=[x,y,z] as Array<Double>
            return pos
        }
        
        func dotProduct3x3(arr1: Array<Array<Double>>, arr2: Array<Array<Double>>) -> Array<Array<Double>>
        {
            let r1c1=arr1[0][0]*arr2[0][0]+arr1[0][1]*arr2[1][0]+arr1[0][2]*arr2[2][0]
            let r2c1=arr1[1][0]*arr2[0][0]+arr1[1][1]*arr2[1][0]+arr1[1][2]*arr2[2][0]
            let r3c1=arr1[2][0]*arr2[0][0]+arr1[2][1]*arr2[1][0]+arr1[2][2]*arr2[2][0]
            let r1c2=arr1[0][0]*arr2[0][1]+arr1[0][1]*arr2[1][1]+arr1[0][2]*arr2[2][1]
            let r2c2=arr1[1][0]*arr2[0][1]+arr1[1][1]*arr2[1][1]+arr1[1][2]*arr2[2][1]
            let r3c2=arr1[2][0]*arr2[0][1]+arr1[2][1]*arr2[1][1]+arr1[2][2]*arr2[2][1]
            let r1c3=arr1[0][0]*arr2[0][2]+arr1[0][1]*arr2[1][2]+arr1[0][2]*arr2[2][2]
            let r2c3=arr1[1][0]*arr2[0][2]+arr1[1][1]*arr2[1][2]+arr1[1][2]*arr2[2][2]
            let r3c3=arr1[2][0]*arr2[0][2]+arr1[2][1]*arr2[1][2]+arr1[2][2]*arr2[2][2]
            let array: [[Double]] = [[r1c1, r1c2, r1c3],[r2c1, r2c2, r2c3],[r3c1, r3c2, r3c3]] as Array<Array<Double>>
            return array
        }
        
        func dotProduct3x1(arr1: Array<Array<Double>>, arr2: Array<Double>) -> Array<Double>
        {
            let x=arr1[0][0]*arr2[0]+arr1[0][1]*arr2[1]+arr1[0][2]*arr2[2]
            let y=arr1[1][0]*arr2[0]+arr1[1][1]*arr2[1]+arr1[1][2]*arr2[2]
            let z=arr1[2][0]*arr2[0]+arr1[2][1]*arr2[1]+arr1[2][2]*arr2[2]
            let array=[x,y,z] as Array<Double>
            return array
        }
        
        //Ecliptic position from cartesian position
        func eclipticPos(pos: Array<Double>, O: Double, i: Double, w: Double) -> Array<Double>
        {
            let array1: [[Double]]=[[cos(O),-sin(O),0],[sin(O),cos(O),0],[0,0,1]]
            
            let array2: [[Double]]=[[1,0,0],[0,cos(i),-sin(i)],[0,sin(i),cos(i)]]
            
            let array3: [[Double]]=[[cos(w),-sin(w),0],[sin(w),cos(w),0],[0,0,1]]
            
            let arr: [[Double]]=dotProduct3x3(arr1: dotProduct3x3(arr1: array1, arr2: array2), arr2: array3)
            
            return dotProduct3x1(arr1: arr, arr2: pos)
        }
        
        //Equatorial position from ecliptic position
        func equatorial(ecpos: Array<Double>, ec: Double, parent: Int) -> Array<Double>
        {
            if parent==1
            {
            let array: [[Double]]=[[1.0,0.0,0.0],[0.0,cos(ec),-sin(ec)],[0.0,sin(ec),cos(ec)]]
            return dotProduct3x1(arr1: array,arr2: ecpos)
            }
            return ecpos
        }
        
        func radians(angle: Double) -> Double
        {
            return angle*(Double.pi/180.0)
        }
        
        func normMinus(vec1: Array<Double>, vec2: Array<Double>) -> Double
        {
            return sqrt(pow(vec1[0]-vec2[0],2)+pow(vec1[1]-vec2[1],2)+pow(vec1[2]-vec2[2],2))
        }
        
        func add3Vec(vec1: SCNVector3, vec2: SCNVector3) -> SCNVector3
        {
            return SCNVector3.init(vec1.x+vec2.x,vec1.y+vec2.y,vec1.z+vec2.z)
        }
        
        func vOrbitSim(a: Double, e: Double, O: Double, I: Double, w: Double, M: Double, sc: Double, parent: Int) -> Array<SCNAction>
        {
            let O=radians(angle: O)
            let I=radians(angle: I)
            let w=radians(angle: w)
            var M=radians(angle: M)
            var positionEq=equatorial(ecpos: eclipticPos(pos: position(a: a,E: newton(M: M,e: e),e: e),O: O,i: I,w: w),ec: radians(angle: 23.437), parent: parent)
            var x=positionEq[0]*sc
            var y=positionEq[1]*sc
            var z=positionEq[2]*sc
            var eq: [[Double]]=[[x,y,z]]
            let period=sqrt(pow(a,3))*365.25
            
            
            var t=0.0
            //Where 0 corresponds to the JD of the central observation (where simulation starts)
            var normArray = [0.0]
            while(t<period+10)
            {
                t=t+1.0
                M=MVcalc(a: a,k: 0.01720209894,mu: 1,T: t)
                let E=newton(M: M,e: e)
                positionEq=equatorial(ecpos: eclipticPos(pos: position(a: a,E: E,e: e),O: O,i: I,w: w),ec: radians(angle: 23.437), parent: parent)
                x=positionEq[0]*sc
                y=positionEq[1]*sc
                z=positionEq[2]*sc
                let eqVec=[x,y,z]
                eq.append(eqVec)
                normArray.append(normMinus(vec1: eq[eq.count-1], vec2: eq[0]))
            }
            
            var actionsArray=[SCNAction]()
            for i in 0...eq.count-1
            {
                if i%5==0 && parent==0
                {
                    let sphereGeometry = SCNSphere(radius: 0.03)
                    sphereGeometry.firstMaterial?.diffuse.contents = UIColor.white
                    let sphereNode = SCNNode(geometry: sphereGeometry)
                    sphereNode.position = SCNVector3(x: Float(eq[i][0]), y: Float(eq[i][1]), z: Float(eq[i][2]))
                    scene.rootNode.addChildNode(sphereNode)
                }
                
                actionsArray.append(SCNAction.move(to: SCNVector3.init(eq[i][0],eq[i][1],eq[i][2]), duration: 0.1))
            }
            return actionsArray
        }
        
        //*************************************************************************
        // retrieve the earth node
        let earth = scene.rootNode.childNode(withName: "earth", recursively: true)!
        //Calculate the positions of the earth using its oribtal elements
        let earthPositions = vOrbitSim(a: 1.000371833989169E+00, e: 1.704239716781501E-02, O: 1.639752443600624E+02, I: 2.669113820737183E-04, w: 2.977668064579176E+02, M:3.581891404220149E+02, sc: 7, parent: 0)
        //Run the earth animations
        earth.runAction(SCNAction.repeatForever(SCNAction.sequence(earthPositions)))
        //earth.runAction(SCNAction.hide())
        
        let moon = scene.rootNode.childNode(withName: "moon", recursively: true)!
        earth.addChildNode(moon)
        let moonPositions = vOrbitSim(a: 2.548289534512777E-03, e: 6.476694137484437E-02, O: 1.239837037681769E+02, I: 5.240010960708354E+00, w: 3.081359025079810E+02, M: 1.407402568949268E+02, sc:200, parent: 1)
        moon.runAction(SCNAction.repeatForever(SCNAction.sequence(moonPositions)))
        //moon.runAction(SCNAction.hide())
        
        let mercury = scene.rootNode.childNode(withName: "mercury", recursively: true)!
        let mercuryPositions = vOrbitSim(a: 3.870982252717257E-01, e: 2.056302512089075E-01, O: 4.833053756455964E+01, I: 7.005014199657344E+00, w: 2.912428058698772E+01, M: 1.727497133778637E+02, sc:7, parent: 0)
        mercury.runAction(SCNAction.repeatForever(SCNAction.sequence(mercuryPositions)))
        //mercury.runAction(SCNAction.hide())
        
        let venus = scene.rootNode.childNode(withName: "venus", recursively: true)!
        let venusPositions = vOrbitSim(a: 7.233268496749391E-01, e: 6.755697267164094E-03, O: 7.667837563371675E+01, I: 3.394589632336535E+00, w: 5.518541455452200E+01, M: 4.931425178852966E+01, sc:7, parent: 0)
        venus.runAction(SCNAction.repeatForever(SCNAction.sequence(venusPositions)))
        //venus.runAction(SCNAction.hide())
        
        let mars = scene.rootNode.childNode(withName: "mars", recursively: true)!
        let marsPositions = vOrbitSim(a: 1.523678184302188E+00, e: 9.331460653723893E-02, O: 4.956199966373916E+01, I: 1.849876609221010E+00, w: 2.865373577554387E+02, M: 1.909450886999620E+01, sc:7, parent: 0)
        mars.runAction(SCNAction.repeatForever(SCNAction.sequence(marsPositions)))
        //mars.runAction(SCNAction.hide())
        
        let ast = scene.rootNode.childNode(withName: "ast", recursively: true)!
        let astPositions = vOrbitSim(a: 2.307355347325137E+00, e: 5.503472901025839E-01, O: 2.151657829181022E+02, I: 3.233604543786646E+00, w: 9.574741833716503E+01, M: 9.872778265595174E+01, sc:7, parent: 0)
        ast.runAction(SCNAction.repeatForever(SCNAction.sequence(astPositions)))
        //ast.runAction(SCNAction.hide())

        //*************************************************************************
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            let originalColor = material.selfIllumination.contents
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.selfIllumination.contents = originalColor
                
                SCNTransaction.commit()
            }
            
            material.selfIllumination.contents = UIColor.green
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
