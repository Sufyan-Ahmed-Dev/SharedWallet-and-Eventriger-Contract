const itemManager = artifacts.require("itemManager");

module.exports = function (deployer) {
  deployer.deploy(itemManager);
};