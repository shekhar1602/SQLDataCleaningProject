Select*                                                                                                  Select*
From [Data Cleaning].dbo.NashvilleHousing 
---Standard Date Format

Select SaleDateConverted, Convert(Date, SaleDate) 
From [Data Cleaning].dbo.NashvilleHousing 

Update [Data Cleaning].dbo.NashvilleHousing 
Set SaleDate= Convert(Date, SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update [Data Cleaning].dbo.NashvilleHousing 
Set SaleDateConverted= Convert(Date, SaleDate)

--Populate Property Address

Select*
From [Data Cleaning].dbo.NashvilleHousing 
--where PropertyAddress is null
order by ParcelId

Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL( a.PropertyAddress, b.PropertyAddress)
From [Data Cleaning].dbo.NashvilleHousing a
join [Data Cleaning].dbo.NashvilleHousing b
   on a.ParcelID=b.ParcelID
   and a.[UniqueID ]<>b.[UniqueID ]
    where a.PropertyAddress is null

	Update a
	Set PropertyAddress= ISNULL( a.PropertyAddress, b.PropertyAddress)
	From [Data Cleaning].dbo.NashvilleHousing a
join [Data Cleaning].dbo.NashvilleHousing b
   on a.ParcelID=b.ParcelID
   and a.[UniqueID ]<>b.[UniqueID ]
    where a.PropertyAddress is null

--- Seperating Address into (Cities States and Address)

Select PropertyAddress
From [Data Cleaning].dbo.NashvilleHousing 
--where PropertyAddress is null
--order by ParcelId

Select
Substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address
  ,Substring(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, Len(PropertyAddress)) as Address
from [Data Cleaning].dbo.NashvilleHousing 


Alter Table [Data Cleaning].dbo.NashvilleHousing
Add PropertyAddressChange Nvarchar(255);

Update [Data Cleaning].dbo.NashvilleHousing 
Set PropertyAddressChange= Substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) 

Alter Table [Data Cleaning].dbo.NashvilleHousing
Add PropertyCityChange Nvarchar(255);

Update [Data Cleaning].dbo.NashvilleHousing 
Set PropertyCityChange= Substring(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, Len(PropertyAddress)) 




Select OwnerAddress
from [Data Cleaning].dbo.NashvilleHousing
where OwnerAddress is not null

Select 
Parsename(Replace(OwnerAddress,',','.'),3)
,Parsename(Replace(OwnerAddress,',','.'),2)
,Parsename(Replace(OwnerAddress,',','.'),1)
from [Data Cleaning].dbo.NashvilleHousing
where OwnerAddress is not null


Alter Table [Data Cleaning].dbo.NashvilleHousing
Add OwnerAddressChange Nvarchar(255);

Update [Data Cleaning].dbo.NashvilleHousing 
Set OwnerAddressChange= Parsename(Replace(OwnerAddress,',','.'),3)

Alter Table [Data Cleaning].dbo.NashvilleHousing
Add OwnerCityChange Nvarchar(255);

Update [Data Cleaning].dbo.NashvilleHousing 
Set OwnerCityChange= Parsename(Replace(OwnerAddress,',','.'),2)


Alter Table [Data Cleaning].dbo.NashvilleHousing
Add OwnerStateChange Nvarchar(255);

Update [Data Cleaning].dbo.NashvilleHousing 
Set OwnerStateChange= Parsename(Replace(OwnerAddress,',','.'),1)

--Change Y and N to Yes and No respectively

Select distinct( SoldAsVacant), Count(SoldAsVacant)
from [Data Cleaning].dbo.NashvilleHousing
Group by (SoldAsVacant)
order by 2

Select SoldAsVacant 
,Case when SoldAsVacant= 'Y' then 'Yes'
      when SoldAsVacant= 'N' then 'NO'
	  Else SoldAsVacant
	  End
from [Data Cleaning].dbo.NashvilleHousing

Update [Data Cleaning].dbo.NashvilleHousing
Set SoldAsVacant=Case when SoldAsVacant= 'Y' then 'Yes'
      when SoldAsVacant= 'N' then 'NO'
	  Else SoldAsVacant
	  End


--Remove Duplicates
With RowNumCTE AS(
Select*,
       Row_Number()	Over(
	   Partition BY  ParcelID,
	                 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order By UniqueID
					 ) row_num
from [Data Cleaning].dbo.NashvilleHousing
--order by ParcelID
)

Select*
from RowNumCTE
Where row_num>1
--Order by PropertyAddress



--Delete Unused Column

Select*                                                                                                  
From [Data Cleaning].dbo.NashvilleHousing

Alter Table [Data Cleaning].dbo.NashvilleHousing
Drop Column OwnerAddress, Acreage,TaxDistrict, SaleDate





