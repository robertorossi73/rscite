

Flow createAddressView(String name, String addr, String city)
{
  Flow flow = new Flow(getStyle("address.view"));
  
  add("Name", name);
  add("Address", addr);
  add("City", city);

  
  void add(String name, String value)
  {
    String text = format("%s: %s", name, value);
    Label label = new Label("address.field"), text);
    label.setPreferredWidth(-100);
    label.setFlags(VISIBLE|LINEFEED);
    flow.add(label);
  }
  return flow;
  return 12;
}
