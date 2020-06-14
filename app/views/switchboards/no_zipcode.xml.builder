xml.instruct!

xml.Response do
  alice_says(builder: xml, message: t('.description'))
  xml.Dial('2022243121')
  xml.Hangup
end