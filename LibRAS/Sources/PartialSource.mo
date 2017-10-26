within LibRAS.Sources;
partial model PartialSource "Partial component source with one fluid connector"
  import Modelica.Constants;
  import Modelica.Fluid.Types;
  parameter Integer nPorts = 0 "Number of ports" annotation(Dialog(connectorSizing = true));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model within the source" annotation(choicesAllMatching = true);
  Medium.BaseProperties medium "Medium in the source";
  LibRAS.Interfaces.WasteFluidPorts_b ports[nPorts](redeclare each package Medium = Medium, m_flow(each max = if flowDirection == Types.PortFlowDirection.Leaving then 0 else +Constants.inf, each min = if flowDirection == Types.PortFlowDirection.Entering then 0 else -Constants.inf)) annotation(Placement(transformation(extent = {{90, 40}, {110, -40}})));
protected
  parameter Types.PortFlowDirection flowDirection = Types.PortFlowDirection.Bidirectional "Allowed flow direction" annotation(Evaluate = true, Dialog(tab = "Advanced"));
equation
// Only one connection allowed to a port to avoid unwanted ideal mixing
  for i in 1:nPorts loop
    assert(cardinality(ports[i]) <= 1, "
each ports[i] of boundary shall at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
    ");
    ports[i].p = medium.p;
    ports[i].h_outflow = medium.h;
    ports[i].Xi_outflow = medium.Xi;
  end for;
  annotation(defaultComponentName = "boundary", Documentation(info = "<html>
<p>
Partial component to model the <b>volume interface</b> of a <b>source</b>
component, such as a mass flow source. The essential
features are:
</p>
<ul>
<li> The pressure in the connection port (= ports.p) is identical to the
  pressure in the volume.</li>
<li> The outflow enthalpy rate (= port.h_outflow) and the composition of the
  substances (= port.Xi_outflow) are identical to the respective values in the volume.</li>
</ul>
</html>"));
end PartialSource;