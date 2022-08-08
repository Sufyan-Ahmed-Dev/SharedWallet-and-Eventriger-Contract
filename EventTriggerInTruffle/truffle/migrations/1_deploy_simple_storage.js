const SimpleStorage = artifacts.require("Item");

module.exports = function (deployer) {
  deployer.deploy(Item);
};
