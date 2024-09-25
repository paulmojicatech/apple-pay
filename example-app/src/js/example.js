import { ApplePay } from 'apple-pay';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    ApplePay.echo({ value: inputValue })
}
