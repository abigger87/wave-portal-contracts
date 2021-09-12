async function main() {
  const [owner, randoPerson] = await ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({ value: hre.ethers.utils.parseEther("0.1")});
  await waveContract.deployed();
  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance))

  let waveCount = await waveContract.getTotalWaves();

  let waveTxn = await waveContract.wave("A message!");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  waveTxn = await waveContract.connect(randoPerson).wave("Another message!");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();

  // ** Send a wave and check if my waves increased
  waveTxn = await waveContract.connect(randoPerson).wave("A third message!");
  await waveTxn.wait();
  let myWaveCount = await waveContract.getMyWaves();

  // ** Let's try and get waves
  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance))
}

main()
.then(() => process.exit(0))
.catch((e) => {
  console.error(e);
  process.exit(1);
});