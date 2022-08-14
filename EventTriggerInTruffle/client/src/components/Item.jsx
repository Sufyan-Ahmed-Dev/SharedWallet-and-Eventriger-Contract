import React, { useState } from 'react'

//problem 1 .. when i add one input value it save in both cost ==itemname   

function Item() {
    {

      const [data ,setData ] = useState({
         cost: "" , itemName : ""
      })
      //  const state = {cost: 0, itemName: "exampleItem1", loaded:false};
        // const a = console.log("hello world")
      var  handleSubmit = async () => {
            // const { cost, itemName } = this.state;
            // console.log(itemName, cost, this.itemManager);
            // let result = await this.itemManager.methods.createItem(itemName, cost).send({ from: this.accounts[0] });
            // console.log(result);
            // alert("Send "+cost+" Wei to "+result.events.SupplyChainStep.returnValues._address);
            alert("function is good")
          };
        
         var handleInputChange = (e) => {

          console.log(e);
          const cost = e.target.value;
          const itemName = e.target.value;
          setData({...data , [cost]:itemName});
           
          // console.log(allData)

          console.log(`Your cost ${cost}`)
          console.log(`Your ItemName Is ${itemName}`);
            // const target = event.target;
            // const value = target.type === 'checkbox' ? target.checked : target.value;
            // const name = target.name;
      
    }
  return (
    <>
     <div className="App">
        <h1>Simply Payment/Supply Chain Example!</h1>
        <h2>Items</h2>

        <h2>Add Element</h2>
        Cost: <input type="text" name="cost"   onChange={handleInputChange}  value ={data.cost}  />
        Item Name: <input type="text" name="itemName" onChange={handleInputChange} value ={data.itemName}/>
        <button type="button" onClick={handleSubmit}>Create new Item</button>
      </div>
    
    </>
  )
}
}
export default Item ;