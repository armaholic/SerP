class blnd_counter {
	idd = -1;
	duration = 1e+011;
	name = "blnd_counter";
	onLoad = "uiNamespace setVariable ['blnd_counter', _this select 0];";
	onUnLoad = "uiNamespace setVariable ['blnd_counter', nil]";
	controls[] = { sttext };
	class sttext
	{
		idc = 2828;
		text = "";
		x = 0.4475 * safezoneW + safezoneX;
		y = 0.0659637 * safezoneH + safezoneY;
		w = 0.1225 * safezoneW;
		h = 0.0420035 * safezoneH;
		deletable = 0;
		fade = 0;
		access = 0;
		type = 13;
		style = 0;
		colorText[] = {1,1,1,1};
		class Attributes
		{
			font = "Zeppelin32";
			color = "#ffffff";
			colorLink = "#D09B43";
			align = "center";
			shadow = 1;
		};
		size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		shadow = 1;
	};
};